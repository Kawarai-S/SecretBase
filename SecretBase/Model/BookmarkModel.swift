//
//  BookmarkModel.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/10/02.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class BookmarkedUsersModel: ObservableObject {
    @Published var bookmarkedUsers: [AppUser] = []
    private var firestore = Firestore.firestore()
    private var authStateManager = FirebaseAuthStateManager.shared  // 1. FirebaseAuthStateManagerのインスタンスを保持
    
    
    //棚をお気に入りに追加
    func addFavorite(userId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = authStateManager.currentUser?.uid else {  // 2. Auth.auth().currentUser?.uidを置き換え
            completion(false)
            return
        }
        
        let userRef = firestore.collection("Users").document(currentUserID)
        
        userRef.updateData([
            "favorites": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("Error adding favorite: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    //お気に入りユーザーの情報の取得
    func fetchUsers(userIds: [String]) {
        var fetchedUsers: [AppUser] = []
        let group = DispatchGroup()
        
        for userId in userIds {
            group.enter()
            let userDocRef = firestore.collection("Users").document(userId)
            userDocRef.getDocument { userDocument, error in
                if let error = error {
                    print("Error fetching user data for \(userId): \(error.localizedDescription)")
                    group.leave()
                    return
                }
                
                guard let userDocument = userDocument, userDocument.exists, let userData = userDocument.data() else {
                    print("Document for \(userId) does not exist or error fetching user data.")
                    group.leave()
                    return
                }
                
                let userName = userData["name"] as? String ?? ""
                let userIcon = userData["icon"] as? String ?? ""
                let userProfile = userData["profile"] as? String ?? ""
                let userFavorites = userData["favorites"] as? [String] ?? []
                
                let user = AppUser(id: userId, name: userName, icon: userIcon, profile: userProfile, shelf: [], favorites: userFavorites)
                fetchedUsers.append(user)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.bookmarkedUsers = fetchedUsers
        }
    }
    
    //お気に入りユーザーの配列（UUID）を取得
    func loadBookmarkedUsers() {
        guard let currentUserId = authStateManager.currentUser?.uid else { return }  // 2. Auth.auth().currentUser?.uidを置き換え
        let userDocRef = firestore.collection("Users").document(currentUserId)
        
        userDocRef.getDocument { [self] userDocument, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            guard let userData = userDocument?.data(), let userFavorites = userData["favorites"] as? [String] else { return }
            self.fetchUsers(userIds: userFavorites)
        }
    }
}
