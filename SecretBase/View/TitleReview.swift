//
//  TitleReview.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/16.
//

import SwiftUI

struct TitleReview: View {
    var user: User
    var item: ShelfItem
    // itemIdを使ってtitles辞書からTitleオブジェクトを取得
    var titleForItem: Title? {
        return titles[item.itemId]
    }
    
    var body: some View {
        ScrollView{
            // titleForItemがnilでなければTitleDetailを表示
            if let title = titleForItem {
                TitleDetail(title: title)
            } else {
                Text("タイトルが見つかりません")
            }
            
            // reviewが空でなければ以下のVStackを表示
            if !item.review.isEmpty {
                VStack(alignment: .leading)  {
                    HStack{
                        UserIconSmall(user: user)
                            .frame(width: 50)
                        Text(user.name)
                    }
                    Text(item.review)
                        .lineSpacing(8)
                    
                    HStack {
                        ForEach(item.likedUsers(from: users), id: \.id) { likedUser in
                            UserIconSmall(user: likedUser)
                                .frame(width: 30)
                        }
                        Spacer()
                        Image(systemName: "star.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
        }
    }
}

extension ShelfItem {
    func likedUsers(from allUsers: [String: User]) -> [User] {
        return likes.compactMap { like in
            return allUsers[like.userId]
        }
    }
}

struct TitleReview_Previews: PreviewProvider {
    static var previews: some View {
        // サンプルのShelfItemを取得。ここではusers["1001"]!の最初のShelfItemを使用しています。
        if let sampleItem = users["1001"]?.shelf.first {
            TitleReview(user: users["1001"]!, item: sampleItem)
        } else {
            Text("Error loading sample item.")
        }
    }
}
