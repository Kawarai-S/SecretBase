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
    
    
    func fetchUserData(for userId: String? = nil) {
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
            }
        }
    }
    
    private func fetchShelf(for userId: String, completion: @escaping ([ShelfItem]?) -> Void) {
        let firestore = Firestore.firestore()
        let shelfRef = firestore.collection("Users").document(userId).collection("shelf")
        
        shelfRef.getDocuments { shelfSnapshot, error in
            guard let shelfSnapshot = shelfSnapshot else {
                completion(nil)
                return
            }
            
            var shelfItems: [ShelfItem] = []
            for shelfDoc in shelfSnapshot.documents {
                let shelfData = shelfDoc.data()
                if
                    let itemId = shelfData["itemId"] as? String,
                    let review = shelfData["review"] as? String,
                    let likesArray = shelfData["likes"] as? [[String: Any]] {
                    var likes: [Like] = []
                    for likeData in likesArray {
                        if let userId = likeData["userId"] as? String {
                            likes.append(Like(userId: userId))
                        }
                    }
                    shelfItems.append(ShelfItem(itemId: itemId, review: review, likes: likes))
                }
            }
            completion(shelfItems)
        }
    }
}


