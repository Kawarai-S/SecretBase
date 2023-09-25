//
//  SwiftUIView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/18.
//

import SwiftUI

struct TitleView: View {
    var user: AppUser
    @EnvironmentObject var userProfileModel: UserProfileModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), alignment: .bottom)]) {
                ForEach(user.shelf, id: \.itemId) { item in
                    // itemIdに基づいてタイトルを取得します
                    if let title = userProfileModel.titleListModel.titles.first(where: { $0.id == item.itemId }) {
                        NavigationLink(destination: TitleReview(user: user, item: item)) {
                            SingleTitleImageView(title: title)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    
    }
}



struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(user: AppUser.dummy)
            .environmentObject(UserProfileModel())
    }
}
