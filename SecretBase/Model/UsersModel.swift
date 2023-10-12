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
    
    //棚の情報を取得
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
    
    //ログインユーザーUIDと一致するドキュメントIDがあるか確認する
    func checkUserInFirestore(showAdditionalInfoModal: Binding<Bool>) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Failed to fetch current user's UID.")
            return
        }
        
        let firestore = Firestore.firestore()
        let userDocRef = firestore.collection("Users").document(currentUserId)
        
        userDocRef.getDocument { userDocument, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let userDocument = userDocument, userDocument.exists {
                // ドキュメントが存在する場合、何もしない
                print("User document exists.")
            } else {
                // ドキュメントが存在しない場合、モーダルを表示
                print("User document does not exist. Showing the modal...")
                showAdditionalInfoModal.wrappedValue = true
            }
        }
    }
}
