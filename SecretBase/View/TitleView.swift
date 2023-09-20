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
//        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100),alignment: .bottom)])
                {
                    ForEach(user.shelf, id: \.itemId) { item in
                        
                        NavigationLink(destination: TitleReview(user: user,item: item)) {  // NavigationLinkの追加
                            // Assetsにある画像を表示
                            Image(item.itemId)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 110)
                        }
                    }
                }
            }
            .padding(.horizontal)
//        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(user: users["1001"]!)
    }
}
