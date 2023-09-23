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
    
    @StateObject private var imageLoader = TitleImageLoader()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100),alignment: .bottom)]) {
                ForEach(user.shelf, id: \.itemId) { item in
                    // itemIdに基づいてタイトルを取得します
                    if let title = userProfileModel.titleListModel.titles.first(where: { $0.id == item.itemId }) {
                        NavigationLink(destination: TitleReview(user: user, item: item)) {
                            if let uiImage = imageLoader.image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 110)
                                    .onAppear {
                                        imageLoader.load(from: title.image)
                                    }
                            } else {
                                Rectangle()  // Placeholder while loading
                                    .foregroundColor(.gray)
                                    .frame(width: 110, height: 110)
                                    .onAppear {
                                        imageLoader.load(from: title.image)
                                    }
                            }
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
        TitleView(user: users["1001"]!)
    }
}
