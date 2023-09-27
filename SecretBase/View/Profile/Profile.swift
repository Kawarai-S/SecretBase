//
//  Profile.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import SwiftUI
import FirebaseAuth

struct Profile: View {
    @ObservedObject private var userProfileModel = UserProfileModel()
    @ObservedObject private var authManager = FirebaseAuthStateManager.shared
    let userId: String?
    
    // ユーザIDを引数で取ることで、ログインユーザー以外のプロフィールも表示可能とします。
    // もしnilが渡された場合、ログインユーザーのプロフィールを表示します。
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            if let user = userProfileModel.user {
                UserIcon(path: user.icon)
                    .frame(width: 72, height: 72)
                Text(user.name)
                Text(user.profile)
                
                // ログインユーザーで、かつ、自分自身のプロフィールを表示している場合に編集リンクを表示します
                if authManager.signInState, authManager.currentUser?.uid == userId {
                    NavigationLink("Edit Profile", destination: ProfileEditor(user: user))
                }
                
            } else {
                Text("Loading or user not found...")
            }
            HStack{
                Spacer()
                if let currentUserId = authManager.currentUser?.uid, currentUserId == userProfileModel.user?.id {
                    Button {
                        authManager.signOut()
                    } label: {
                        Text("SignOut")
                    }
                }
            }

        }
        .onAppear {
            self.userProfileModel.fetchUserData(for: userId)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
