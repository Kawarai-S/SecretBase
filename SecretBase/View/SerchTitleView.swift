//
//  SerchTitleView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/19.
//

import SwiftUI

struct SerchTitleView: View {
    var title:Title
    var usersWithThisTitle: [User] {
        let filteredUsers = users.values.filter { user in
            user.shelf.contains(where: { $0.itemId == title.id })
        }
        print("Filtered users count: \(filteredUsers.count)")
        return filteredUsers
    }

    let loggedInUser: User = users["1001"]! 
    
    var body: some View {
//        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    TitleDetail(title: title)
                    
                    VStack(alignment: .leading){
                        Button {
                            
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "plus.square")
                                Text("棚に作品を追加する")
                                Spacer()
                            }
                        }
                        .frame(width: .infinity)
                        .padding()
                        .clipShape(RoundedRectangle(cornerRadius: 10))  // 角丸の形にクリッピング
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)  // 角丸の形のオーバーレイを作成
                                .stroke(Color.blue, lineWidth: 1)  // 線の色と太さを設定
                        )
                        
                        Text("この作品を好きな人")
                            .padding(.top)
                        ForEach(usersWithThisTitle.prefix(3), id: \.id) { user in
                            NavigationLink(destination: Shelf(user: user)) {
                                HStack {
                                    UserIconSmall(user: user)
                                        .frame(width: 32, height: 32)
                                    Text(user.name)
                                }
                            }
                        }
                        NavigationLink(destination: UsersListView(users: usersWithThisTitle)) {
                            HStack {
                                Spacer()
                                Text("もっとみる")
                            }
                                
                        }
                    }
                    .padding()
                }
                
            }
//        }
    }
}

struct SerchTitleView_Previews: PreviewProvider {
    static var previews: some View {
        if let sampleTitle = titles["013"] {
            SerchTitleView(title: sampleTitle)
        } else {
            Text("Sample title not found.")
        }    }
}
