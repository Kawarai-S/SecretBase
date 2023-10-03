//
//  LikedUsersListView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/10/03.
//

import SwiftUI

struct LikedUsersListView: View {
    var likedUsers: [AppUser]
    
    var body: some View {
        List(likedUsers, id: \.id) { user in
            NavigationLink(destination: OtherUserShelf(userId: user.id, userProfileModel: UserProfileModel(), bookmarkedUsersModel: BookmarkedUsersModel())) {
                HStack {
                    UserIcon(path: user.icon)
                        .frame(width: 42, height: 42)
                    Text(user.name)
                }
            }
        }
        .listStyle(.inset)
        .navigationBarTitle("ふぁぼしたユーザー", displayMode: .inline)
    }
}


//struct LikedUsersListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikedUsersListView()
//    }
//}
