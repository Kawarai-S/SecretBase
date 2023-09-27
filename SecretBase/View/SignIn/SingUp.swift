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
    @State private var navigateToAdditionalInfo: Bool = false  // ← 初期値を設定
    
    var body: some View {
        NavigationView {
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
                            self.navigateToAdditionalInfo = true  // ← 'self.'を追加
                        } else {
                            // Handle error (e.g., show an alert)
                        }
                    }
                }
                
                NavigationLink(destination: AdditionalInfoView(), isActive: $navigateToAdditionalInfo) {
                    EmptyView()
                }
                .hidden() // NavigationLinkを非表示にする
            }
            .padding()
        }
    }
}


//struct SingUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingUp()
//    }
//}
