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
    
    // サインインが成功したかどうかを判断するState変数
    @State private var isSignInSuccessful: Bool = false
    // アラートを表示するかどうかを判断するState変数
    @State private var showAlert: Bool = false
    
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
                        isSignInSuccessful = true
                    } else {
                        print("Error: \(error?.localizedDescription ?? "Unknown Error")")
                        showAlert = true  // アラートを表示する
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5.0)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Sign in failed."), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $isSignInSuccessful, content: {
            ContentView()
        })
    }
}


//struct SignIn_Previews: PreviewProvider {
//    static var previews: some View {
//        SignIn()
//    }
//}
