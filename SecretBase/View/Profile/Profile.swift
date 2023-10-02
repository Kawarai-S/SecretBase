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
    
    @State private var showProfileEditor = false
    
    var body: some View {
        NavigationStack{
            VStack {
                if let user = userProfileModel.user {
                    UserIcon(path: user.icon)
                        .frame(width: 100, height: 100)
                    Text(user.name)
                        .font(.title2)
                    Text(user.profile)
                        .font(.subheadline)
                        .padding(.top)
                        .frame(maxWidth: 300)
                    
                    // ログインユーザーで、かつ、自分自身のプロフィールを表示している場合に編集リンクを表示します
                    if authManager.signInState, authManager.currentUser?.uid == userId {
                        Button("プロフィール編集") {
                            showProfileEditor = true
                        }
                        .modifier(OverlayButtonModifier(maxWidth: 150, paddingValue: 8))
                        .foregroundColor(Color("MainColor2"))
                        .padding(.top)
                        .background(
                            NavigationLink("", destination: ProfileEditor(user: user), isActive: $showProfileEditor)
                                .opacity(0) // これによりNavigationLinkは見えなくなります
                        )
                    }
                    
                } else {
                    Text("Loading or user not found...")
                }
                if let currentUserId = authManager.currentUser?.uid, currentUserId == userProfileModel.user?.id {
                    Button {
                        authManager.signOut()
                    } label: {
                        Text("SignOut")
                    }
                    .modifier(OverlayButtonModifier(maxWidth: 150, paddingValue: 8))
                    .foregroundColor(Color("MainColor2"))
                }
            }
            .onAppear {
                self.userProfileModel.fetchUserData(for: userId)
            }
            .padding()
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
