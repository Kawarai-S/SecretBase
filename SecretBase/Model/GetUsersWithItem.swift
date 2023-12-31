//
//  GetUsersWithItem.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/26.
//

import Foundation
import FirebaseFirestore

func getUsersWithItem(itemId: String, completion: @escaping ([AppUser]) -> Void) {
    print("getUsersWithItem called with itemId: \(itemId)")
    let firestore = Firestore.firestore()
    let usersRef = firestore.collection("Users")
    
    usersRef.getDocuments { (snapshot, error) in
        if let error = error {
            print("Error fetching users: \(error.localizedDescription)")
            completion([])
            return
        }
        
        guard let snapshot = snapshot else {
            print("No user snapshot found")
            completion([])
            return
        }
        
        var usersWithItem: [AppUser] = []
        
        let group = DispatchGroup()
        for userDoc in snapshot.documents {
            group.enter()
            let userId = userDoc.documentID
            let shelfRef = usersRef.document(userId).collection("shelf").whereField("itemid", isEqualTo: itemId)
            shelfRef.getDocuments { (shelfSnapshot, shelfError) in
                if let _ = shelfError {
                    group.leave()
                    return
                }
                
                guard let shelfSnapshot = shelfSnapshot, !shelfSnapshot.documents.isEmpty else {
                    group.leave()
                    return
                }
                
                let userData = userDoc.data()
                guard
                    let name = userData["name"] as? String,
                    let icon = userData["icon"] as? String,
                    let profile = userData["profile"] as? String
                else {
                    print("Failed to retrieve user data for user: \(userId)")
                    group.leave()
                    return
                }
                    let userFavorites = userData["favorites"] as? [String] ?? []
                
                let user = AppUser(id: userId, name: name, icon: icon, profile: profile, shelf: [], favorites: userFavorites)
                usersWithItem.append(user)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("Fetched Users: \(usersWithItem)")
            completion(usersWithItem)
        }
    }
}


class SearchTitleViewModel: ObservableObject {
    @Published var usersWithThisTitle: [AppUser] = []
    var title: Title
    
    init(title: Title) {
        self.title = title
    }
    
    func fetchUserData(for userId: String, completion: @escaping (AppUser?) -> Void) {
        let firestore = Firestore.firestore()
        let userDocRef = firestore.collection("Users").document(userId)
        
        userDocRef.getDocument { userDocument, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let userDocument = userDocument, userDocument.exists, let userData = userDocument.data() else {
                print("Document does not exist or error fetching user data.")
                completion(nil)
                return
            }
            
            let userName = userData["name"] as? String ?? ""
            let userIcon = userData["icon"] as? String ?? ""
            let userProfile = userData["profile"] as? String ?? ""
            let userFavorites = userData["favorites"] as? [String] ?? []
            let user = AppUser(id: userId, name: userName, icon: userIcon, profile: userProfile, shelf: [], favorites: userFavorites)

            completion(user)
        }
    }
    
    func fetchUsersWithItem() {
        getUsersWithItem(itemId: title.id) { fetchedUsers in
            let group = DispatchGroup()
            var completedUsers: [AppUser] = []
            
            for user in fetchedUsers {
                group.enter()
                self.fetchUserData(for: user.id) { completedUser in
                    if let completedUser = completedUser {
                        completedUsers.append(completedUser)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.usersWithThisTitle = completedUsers
            }
        }
    }
}


