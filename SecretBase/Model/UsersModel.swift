//
//  UsersModel.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class UserProfileModel: ObservableObject {
    @Published var user: AppUser? = nil
    @Published var titleListModel = TitleListModel()
    //ファボした人を読み込むための配列
    @Published var likedUsers: [AppUser] = []
    
    init() {
        titleListModel.fetchData()  // データを取得
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
            let userFavorites = userData["favorites"] as? [String] ?? []  // この行を追加
            
            self.fetchShelf(for: targetUserId) { shelfItems in
                let user = AppUser(id: targetUserId, name: userName, icon: userIcon, profile: userProfile, shelf: shelfItems ?? [], favorites: userFavorites) // favoritesを追加
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
    
    //ファボした人を読み込む
    func loadLikedUsers(for likes: [Like]) {
        fetchLikedUsers(for: likes) { users in
            print("Fetched liked users: \(users)")
            self.likedUsers = users
            print("Updated likedUsers: \(self.likedUsers)")
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

//likedUserを取得
extension UserProfileModel {
    
    func fetchLikedUsers(for likes: [Like], completion: @escaping ([AppUser]) -> Void) {
        let firestore = Firestore.firestore()
        let usersRef = firestore.collection("Users")
        
        let likedUserIds = likes.map { $0.userId }
        
        // likedUserIdsが空の場合は直ちに空の配列を返して終了
        guard !likedUserIds.isEmpty else {
            completion([])
            return
        }
        
        // バッチで複数のドキュメントを一度に取得
        usersRef.whereField(FieldPath.documentID(), in: likedUserIds).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching liked users: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let snapshot = snapshot else {
                print("Error fetching snapshot for liked users")
                completion([])
                return
            }
            
            let likedUsers = snapshot.documents.compactMap { doc -> AppUser? in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let icon = data["icon"] as? String,
                      let profile = data["profile"] as? String else {
                    return nil
                    }
                      let userFavorites = data["favorites"] as? [String] ?? []
                return AppUser(id: doc.documentID, name: name, icon: icon, profile: profile, shelf: [], favorites: userFavorites)  // shelfは空で初期化
            }
            
            completion(likedUsers)
        }
    }
}



