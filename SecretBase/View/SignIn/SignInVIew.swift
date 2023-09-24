//
//  SignInVIew.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import SwiftUI

struct SignInVIew: View {
    @State var isShowSheet = false
    var body: some View {
        VStack{
            Button(action: {
                self.isShowSheet.toggle()
            }) {
                Text("Sign-In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isShowSheet) {
            SignIn(isShowSheet: $isShowSheet)
        }
    }
}

struct SignInVIew_Previews: PreviewProvider {
    static var previews: some View {
        SignInVIew()
    }
}
