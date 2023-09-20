//
//  Shelf.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Shelf: View {
    var user: User
    
    var body: some View {
        let loggedInUser: User = users["1001"]! 
//        NavigationView {
            VStack{
                HStack{
                    if user.id == loggedInUser.id {
                        Button {
                            // 作品を追加するアクション
                        } label: {
                            Image(systemName: "plus.square")
                            Text("作品を追加する")
                        }
                    } else {
                        Button {
                            // お気に入りに登録するアクション
                        } label: {
                            Image(systemName: "bookmark.fill")
                            Text("お気に入りに登録する")
                        }
                    }
                    
                    Spacer()
                    Text(user.name)
                    UserIconSmall(user: user)
                        .frame(width: 48,height: 48)
                }
                .padding(.horizontal)
                
                TitleView(user: user)
            }
//        }
    }
}

struct Shelf_Previews: PreviewProvider {
    static var previews: some View {
        Shelf(user: users["1001"]!)
    }
}
