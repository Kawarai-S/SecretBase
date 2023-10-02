//
//  OtherUserShelf.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/26.
//

import SwiftUI

struct OtherUserShelf: View {
    var userId: String
    // @ObservedObjectを保持し、初期化は行わない
    @ObservedObject var userProfileModel: UserProfileModel
    @ObservedObject var bookmarkedUsersModel: BookmarkedUsersModel
    @State private var showProfileModal: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    bookmarkedUsersModel.addFavorite(userId: userId) { success in
                        if success {
                            print("Successfully added to favorites!")
                        } else {
                            print("Error adding to favorites.")
                        }
                    }
                } label: {
                    Image(systemName: "bookmark.fill")
                    Text("お気に入りに登録する")
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
            
            TitleView(user: userProfileModel.user ?? .dummy, userProfileModel: userProfileModel)
        }
        
        
        .onAppear {
            userProfileModel.fetchUserData(for: userId) {
                // データが取得された後の処理
                if let user = self.userProfileModel.user {
                    print("User's Shelf: \(user.shelf)")
                }
            }
        }
        .sheet(isPresented: $showProfileModal) {
            Profile(userId: userId) // userIdを渡す
        }
    }
}

//struct OtherUserShelf_Previews: PreviewProvider {
//    static var previews: some View {
//        OtherUserShelf(userId: "testUserId")
//            .environmentObject(UserProfileModel())
//    }
//}

