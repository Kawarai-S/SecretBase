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

class UserService:ObservableObject {
    func addLike(to item: ShelfItem, for reviewOwner: AppUser, by userId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let firestore = Firestore.firestore()
        // レビューの持ち主のドキュメントを指す参照を取得
        let shelfCollectionRef = firestore.collection("Users").document(reviewOwner.id).collection("shelf")
        
        shelfCollectionRef.whereField("itemid", isEqualTo: item.itemId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("Document with specified itemId not found.")
                completion(false)
                return
            }
            
            let docRef = document.reference
            // ログインしているユーザーのIDで「いいね」を追加
            let newLikeMap = ["userId": userId]
            docRef.updateData([
                "likes": FieldValue.arrayUnion([newLikeMap])
            ]) { err in
                if let err = err {
                    print("Error adding like: \(err)")
                    completion(false)
                } else {
                    print("Like successfully added!")
                    completion(true)
                }
            }
        }
    }
    
    func removeLike(from item: ShelfItem, for reviewOwner: AppUser, by userId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let firestore = Firestore.firestore()
        let shelfCollectionRef = firestore.collection("Users").document(reviewOwner.id).collection("shelf")
        
        shelfCollectionRef.whereField("itemid", isEqualTo: item.itemId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("Document with specified itemId not found.")
                completion(false)
                return
            }
            
            let docRef = document.reference
            let likeMapToRemove = ["userId": userId]
            docRef.updateData([
                "likes": FieldValue.arrayRemove([likeMapToRemove])
            ]) { err in
                if let err = err {
                    print("Error removing like: \(err)")
                    completion(false)
                } else {
                    print("Like successfully removed!")
                    completion(true)
                }
            }
        }
    }
    
    func fetchLikedUsers(for item: ShelfItem, completion: @escaping ([AppUser]?) -> Void) {
        guard let likes = item.likes else {
            completion([])
            return
        }
        
        let firestore = Firestore.firestore()
        let usersRef = firestore.collection("Users")
        
        let likedUserIds = likes.map { $0.userId }
        
        // likedUserIdsが空の場合は直ちに空の配列を返して終了
        guard !likedUserIds.isEmpty else {
            completion([])
            return
        }
        
        usersRef.whereField(FieldPath.documentID(), in: likedUserIds).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching liked users: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot else {
                print("Error fetching snapshot for liked users")
                completion(nil)
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
            print("Fetched liked users: \(likedUsers)")
            completion(likedUsers)
        }
    }
}
