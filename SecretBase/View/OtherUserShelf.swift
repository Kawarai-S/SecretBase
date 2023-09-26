//
//  OtherUserShelf.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/26.
//

import SwiftUI

struct OtherUserShelf: View {
    var userId: String
    @ObservedObject private var userProfileModel = UserProfileModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    // お気に入りに登録するアクション
                } label: {
                    Image(systemName: "bookmark.fill")
                    Text("お気に入りに登録する")
                }
                
                Spacer()
                
                Button(action: {
                    // Other user's profile modal
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
        }
        .onAppear {
            userProfileModel.fetchUserData(for: userId) {
                // データが取得された後の処理
                if let user = self.userProfileModel.user {
                    print("User's Shelf: \(user.shelf)")
                }
            }
        }
    }
}

struct OtherUserShelf_Previews: PreviewProvider {
    static var previews: some View {
        OtherUserShelf(userId: "testUserId")
            .environmentObject(UserProfileModel())
    }
}

