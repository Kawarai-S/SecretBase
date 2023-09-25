//
//  SingleTitleImageView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/25.
//

import SwiftUI

struct SingleTitleImageView: View {
    var title: Title
    @StateObject private var imageLoader = TitleImageLoader()
    
    var body: some View {
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

//struct SingleTitleImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleTitleImageView()
//    }
//}
