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
            HStack {
                UserIcon(path: user.icon)
                    .frame(width: 50)
                Text(user.name)
            }
        }
        .navigationBarTitle("いいねを押したユーザー", displayMode: .inline)
    }
}


//struct LikedUsersListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikedUsersListView()
//    }
//}
