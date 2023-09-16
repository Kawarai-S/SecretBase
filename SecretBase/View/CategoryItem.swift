//
//  CategoryItem.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/17.
//

import SwiftUI

struct CategoryItem: View {
    var body: some View {
        VStack(alignment: .leading){
            Image("001")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .cornerRadius(5)
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItem()
    }
}
