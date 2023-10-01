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
    
    //「作品を追加する」ボタンのタブ切り替え用
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack {
            HStack {
                
                Button {
                    selectedTab = 1
                } label: {
                    Image(systemName: "plus.square")
                    Text("作品を追加する")
                }
                .frame(maxWidth: 200)
                .padding(8)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("MainColor2"), lineWidth: 1))
                
                Spacer()
                
                // ユーザー情報
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
            
            TitleView(user: userProfileModel.user ?? .dummy, userProfileModel: userProfileModel)
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
        // Profileモーダルの表示
        .sheet(isPresented: $showProfileModal) {
            Profile(userId: authStateManager.currentUser?.uid ?? "")
        }
    }
}

//struct Shelf_Previews: PreviewProvider {
//    static var previews: some View {
//        Shelf()
//            .environmentObject(UserProfileModel())
//    }
//}

