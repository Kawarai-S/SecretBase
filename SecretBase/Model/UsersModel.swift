//
//  UsersModel.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserProfileModel: ObservableObject {
    @Published var user: AppUser? = nil
    @Published var titleListModel = TitleListModel()
    
    init() {
        titleListModel.fetchData()  // データを取得します
    }
    
    
    func fetchUserData(for userId: String? = nil, completion: (() -> Void)? = nil) {
        let targetUserId: String
        if let userId = userId {
            targetUserId = userId
        } else {
            guard let authUserId = Auth.auth().currentUser?.uid else { return }
            targetUserId = authUserId
        }
        
        let firestore = Firestore.firestore()
        let userDocRef = firestore.collection("Users").document(targetUserId)
        
        userDocRef.getDocument { userDocument, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let userDocument = userDocument, userDocument.exists, let userData = userDocument.data() else {
                print("Document does not exist or error fetching user data: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            let userName = userData["name"] as? String ?? ""
            let userIcon = userData["icon"] as? String ?? ""
            let userProfile = userData["profile"] as? String ?? ""
            
            self.fetchShelf(for: targetUserId) { shelfItems in
                let user = AppUser(id: targetUserId, name: userName, icon: userIcon, profile: userProfile, shelf: shelfItems ?? [])
                self.user = user
                completion?() 
            }
        }
    }
    
    private func fetchShelf(for userId: String, completion: @escaping ([ShelfItem]?) -> Void) {
        let firestore = Firestore.firestore()
        let shelfRef = firestore.collection("Users").document(userId).collection("shelf")
        
        shelfRef.getDocuments { shelfSnapshot, error in
            // エラーがある場合、そのエラーを出力
            if let error = error {
                print("Error fetching shelf documents: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let shelfSnapshot = shelfSnapshot else {
                completion(nil)
                return
            }
            
            // ドキュメントの数を出力
            print("Number of documents in shelf: \(shelfSnapshot.documents.count)")
            
            var shelfItems: [ShelfItem] = []
            for shelfDoc in shelfSnapshot.documents {
                let shelfData = shelfDoc.data()
                if
                    let itemId = shelfData["itemid"] as? String,
                    let review = shelfData["review"] as? String
                {
                    var likes: [Like] = []
                    if let likesArray = shelfData["likes"] as? [[String: Any]] {
                        for likeData in likesArray {
                            if let userId = likeData["userId"] as? String {
                                likes.append(Like(userId: userId))
                            } else {
                                print("Error parsing likeData in document \(shelfDoc.documentID): \(likeData)")
                            }
                        }
                    } else {
                        print("Likes data missing or not in expected format in document \(shelfDoc.documentID)")
                    }
                    shelfItems.append(ShelfItem(itemId: itemId, review: review, likes: likes))
                } else {
                    print("Error parsing shelfData in document \(shelfDoc.documentID): \(shelfData)")
                }
            }
            
            // completionが呼び出される前のshelfItemsの状態を出力
            print("Completion called with \(shelfItems.count) items.")
            completion(shelfItems)
        }
    }
}


extension ShelfItem {
    func likedUsers(from users: [AppUser]) -> [AppUser] {
        // likesがnilの場合は空の配列を返す
        guard let likes = self.likes else { return [] }
        
        return likes.compactMap { like in
            return users.first { $0.id == like.userId }
        }
    }
}

//作品を棚に追加する
func addShelfItem(item: ShelfItem, for userId: String, completion: @escaping (Bool) -> Void) {
    let firestore = Firestore.firestore()
    let shelfRef = firestore.collection("Users").document(userId).collection("shelf")
    
    let data: [String: Any] = [
        "itemid": item.itemId,
        "review": item.review ?? "",
        "likes": item.likes?.map { ["userId": $0.userId] } ?? []
    ]
    
    shelfRef.addDocument(data: data) { error in
        if let error = error {
            print("Error adding shelf item: \(error.localizedDescription)")
            completion(false)
        } else {
            completion(true)
        }
    }
}

func addTitleToShelf(for title: Title, completion: @escaping (Bool) -> Void) {
    let shelfItem = ShelfItem(itemId: title.id, review: nil, likes: nil)
    if let currentUserId = Auth.auth().currentUser?.uid {
        addShelfItem(item: shelfItem, for: currentUserId) { success in
            completion(success)
        }
    } else {
        completion(false)
    }
}

//レビュー投稿
func submitReview(for itemId: String, reviewText: String, completion: @escaping (ReviewAlertType) -> Void) {
    let shelfItem = ShelfItem(itemId: itemId, review: reviewText, likes: nil)
    if let currentUserId = Auth.auth().currentUser?.uid {
        addShelfItem(item: shelfItem, for: currentUserId) { success in
            if success {
                completion(.success)
            } else {
                completion(.error)
            }
        }
    } else {
        completion(.error) // 失敗
    }
}

enum ReviewAlertType: Identifiable {
    case success, error
    
    var id: Int {
        switch self {
        case .success:
            return 1
        case .error:
            return 2
        }
    }
}

func updateReview(for itemId: String, reviewText: String, completion: @escaping (ReviewAlertType) -> Void) {
    guard let currentUserId = Auth.auth().currentUser?.uid else {
        completion(.error)
        return
    }
    
    let firestore = Firestore.firestore()
    let shelfRef = firestore.collection("Users").document(currentUserId).collection("shelf")
    
    // itemIdを元にドキュメントを特定し、そのドキュメントのレビュー部分のみを更新します
    shelfRef.whereField("itemid", isEqualTo: itemId).getDocuments { (snapshot, error) in
        if let error = error {
            print("Error getting document: \(error.localizedDescription)")
            completion(.error)
            return
        }
        
        guard let document = snapshot?.documents.first else {
            print("Document does not exist.")
            completion(.error)
            return
        }
        
        document.reference.updateData(["review": reviewText]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.error)
            } else {
                completion(.success)
            }
        }
    }
}

// レビューを編集・追記する
