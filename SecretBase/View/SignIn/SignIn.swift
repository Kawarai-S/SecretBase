//
//  SignIn.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/24.
//

import SwiftUI

struct SignIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var authManager = FirebaseAuthStateManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
            
            Button("Sign In") {
                authManager.signIn(withEmail: email, password: password) { success, error in
                    if success {
                        print("Signed In Successfully!")
                    } else {
                        print("Error: \(error?.localizedDescription ?? "Unknown Error")")
                    }
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(5.0)
        }
        .padding()
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
