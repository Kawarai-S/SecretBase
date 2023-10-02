//
//  BookmarkView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/10/02.
//

import SwiftUI

struct BookmarkView: View {
    @ObservedObject var bookmarkedModel = BookmarkedUsersModel()
    @ObservedObject var userProfileModel = UserProfileModel()
    
    
    var body: some View {
        VStack {
            // 画面の上部に「Bookmark」と表示
            Text("Bookmark")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .fontWeight(.medium)
                .padding(.bottom)
                .background(Color("MainColor"))
            
            VStack(alignment: .leading, spacing: 15) {
                HStack{
                    Image(systemName: "bookmark.circle.fill")
                        .foregroundColor(Color("SubColor1"))
                    Text("お気に入りの棚")
                }
                    .font(.headline)
                    .padding(.leading, 5)
                
                List(bookmarkedModel.bookmarkedUsers, id: \.id) { user in
                    NavigationLink(destination: OtherUserShelf(userId: user.id, userProfileModel: userProfileModel, bookmarkedUsersModel: bookmarkedModel)) {
                        HStack {
                            UserIcon(path: user.icon)
                                .frame(width: 32, height: 32)
                            Text(user.name)
                        }
                    }
                }
            }
            .padding()
            // お気に入りのレビューリストをこちらに追加する場合
            // その際、上のListとは別に新たなListを追加する
        }
        .listStyle(.inset)
        
        .onAppear(perform: bookmarkedModel.loadBookmarkedUsers)
    }
}


//struct BookmarkView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookmarkView()
//    }
//}
