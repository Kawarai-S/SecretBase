//
//  SignInVIew.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import SwiftUI

struct SignInVIew: View {
    @ObservedObject private var authStateManager = FirebaseAuthStateManager.shared
    @State var isShowSheet = false
    @State var isFullScreen = false
    var body: some View {
        VStack{
            Button(action: {
                self.isShowSheet.toggle()
            }) {
                Text("Sign-In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding()
        }
        .sheet(isPresented: $isShowSheet) {
            FirebaseUIView()
        }
    }
}

struct SignInVIew_Previews: PreviewProvider {
    static var previews: some View {
        SignInVIew()
    }
}
