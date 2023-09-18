//
//  SwiftUIView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/18.
//

import SwiftUI

struct TitleView: View {
    var user: User
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100),alignment: .bottom)]) {
                ForEach(user.shelf, id: \.itemId) { item in
                    // Assetsにある画像を表示
                    Image(item.itemId)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 110)
                }
            }
        }
        .padding()
    }
}

struct TitleView_Previews: PreviewProvider {
    static let sampleUsers: [String: User] = load("Users.json")
    //最初のユーザーを取得する
    static let firstUser = sampleUsers["1001"]!
    
    static var previews: some View {
        TitleView(user: firstUser)
    }
}
