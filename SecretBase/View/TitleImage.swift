//
//  TitleImage.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/16.
//

import SwiftUI

struct TitleImage: View {
    var image: String
    
    var body: some View {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 120)
    }
}

struct TitleImage_Previews: PreviewProvider {
    static var previews: some View {
        TitleImage(image: "001")
    }
}
