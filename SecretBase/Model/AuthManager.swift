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
            if let user = user {
                print("Logged in as: \(user.uid)")
                self.currentUser = user
                self.signInState = true
            } else {
                print("User not logged in")
                self.currentUser = nil
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
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
    
    func signUp(withEmail email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }

}

