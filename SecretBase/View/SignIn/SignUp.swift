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
    @State private var navigateToAdditionalInfo: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .border(Color.gray)
                
                SecureField("Password", text: $password)
                    .padding()
                    .border(Color.gray)
                
                Button("Sign Up") {
                    FirebaseAuthStateManager.shared.signUp(withEmail: email, password: password) { success, error in
                        if success {
                            self.navigateToAdditionalInfo = true
                        } else {
                            self.errorMessage = error?.localizedDescription ?? "Unknown error"
                            self.showAlert = true
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(isPresented: $navigateToAdditionalInfo) {
                    AdditionalInfoView()
                }
                
            }
            .padding()
        }
    }
}



struct SingUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
