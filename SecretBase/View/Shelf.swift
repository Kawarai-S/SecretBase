//
//  Shelf.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Shelf: View {
    @ObservedObject private var userProfileModel = UserProfileModel()
    @ObservedObject private var authStateManager = FirebaseAuthStateManager.shared
    @State private var showProfileModal: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                
                Button {
                    // 作品を追加するアクション
                } label: {
                    Image(systemName: "plus.square")
                    Text("作品を追加する")
                }
                
                
                
                Spacer()
                
                Button(action: {
                    showProfileModal = true
                }) {
                    HStack {
                        Text(userProfileModel.user?.name ?? "Loading...")
                        if let user = userProfileModel.user {
                            UserIcon(path: user.icon)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            TitleView(user: userProfileModel.user ?? .dummy)
            // Profileモーダルの表示
                .sheet(isPresented: $showProfileModal) {
                    Profile(userId: authStateManager.currentUser?.uid ?? "")
                }
        }
        .onAppear {
            if let currentUser = authStateManager.currentUser {
                userProfileModel.fetchUserData(for: currentUser.uid) {
                    // データが取得された後の処理
                    if let user = self.userProfileModel.user {
                        print("User's Shelf: \(user.shelf)")
                    }
                }
            } else {
                print("No current user found in onAppear.")
            }
        }
    }
}

struct Shelf_Previews: PreviewProvider {
    static var previews: some View {
        Shelf()
            .environmentObject(UserProfileModel())
    }
}

