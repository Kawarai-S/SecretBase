//
//  TitleReview.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/16.
//

import SwiftUI

struct TitleReview: View {
    var user: AppUser
    var item: ShelfItem
    @EnvironmentObject var userProfileModel: UserProfileModel  // ← 追加: UserProfileModelを参照
    
    var titleForItem: Title? {
        return userProfileModel.titleListModel.titles.first { $0.id == item.itemId }  // ← titles の代わりに userProfileModel.titleListModel.titles を使用
    }
    
    var body: some View {
        ScrollView {
            if let title = titleForItem {
                TitleDetail(title: title)
                    .padding()
                
                if let review = item.review, !review.isEmpty {
                    VStack(alignment: .leading) {
                        HStack {
                            UserIconSmall(user: user)
                                .frame(width: 50)
                            Text(user.name)
                        }
                        Text(review)
                            .lineSpacing(8)
                        
                        HStack {
                            ForEach(item.likedUsers(from: Array(users.values)), id: \.id) { likedUser in
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
            } else {
                Text("タイトルが見つかりません")
            }
        }
    }
}


//extension ShelfItem {
//    func likedUsers(from allUsers: [String: AppUser]) -> [AppUser] {
//        return likes.compactMap { like in
//            return allUsers[like.userId]
//        }
//    }
//}
//
//struct TitleReview_Previews: PreviewProvider {
//    static var previews: some View {
//        // サンプルのShelfItemを取得。ここではusers["1001"]!の最初のShelfItemを使用しています。
//        if let sampleItem = users["1001"]?.shelf.first {
//            TitleReview(user: users["1001"]!, item: sampleItem)
//        } else {
//            Text("Error loading sample item.")
//        }
//    }
//}
