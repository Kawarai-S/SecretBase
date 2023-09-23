//
//  FirebaseUIView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/21.
//

import SwiftUI
import FirebaseAuthUI
import FirebaseEmailAuthUI

struct FirebaseUIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        // サポートするログイン方法を構成
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth()
        ]
        authUI.providers = providers
        
        // FirebaseUIを表示する
        let authViewController = authUI.authViewController()
        
        return authViewController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct FirebaseUIView_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseUIView()
    }
}

