//
//  UsersListView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/20.
//

import SwiftUI

struct UsersListView: View {
    var users: [AppUser]
    
    var body: some View {
        List(users, id: \.id) { user in
            HStack{
                UserIcon(path: user.icon)
                    .frame(width: 32, height: 32)
                Text(user.name)
            }
        }
        .listStyle(.inset)
        .navigationBarTitle("この作品を好きな人", displayMode: .inline)
    }
}

//struct UsersListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsersListView()
//    }
//}