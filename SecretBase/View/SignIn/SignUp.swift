//
//  SingUpView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/27.
//

import SwiftUI

struct SignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.gray, lineWidth: 1))
                .background(Color.white)
                .cornerRadius(5.0)
            
            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.gray, lineWidth: 1))
                .background(Color.white)
                .cornerRadius(5.0)
            
            Button("Sign Up") {
                FirebaseAuthStateManager.shared.signUp(withEmail: email, password: password) { success, error in
                    if !success {
                        self.errorMessage = error?.localizedDescription ?? "Unknown error"
                        self.showAlert = true
                    }
                }
            }
            .modifier(MainButtonModifier())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}



struct SingUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
