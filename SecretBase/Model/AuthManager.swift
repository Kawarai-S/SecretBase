//
//  AuthManager.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/21.
//

import FirebaseAuth

class FirebaseAuthStateManager: ObservableObject {
    @Published var signInState: Bool = false
    @Published var currentUser: User?
    static let shared = FirebaseAuthStateManager()
    
    private var handle: AuthStateDidChangeListenerHandle!
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user // この行を追加
            if let _ = user {
                self.signInState = true
            } else {
                self.signInState = false
            }
        }
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error")
        }
    }
}

