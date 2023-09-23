//
//  UserIcon.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/23.
//

import SwiftUI

struct UserIcon: View {
    @ObservedObject var loader: UserIconLoader
    var placeholder: Image
    
    init(path: String, placeholder: Image = Image(systemName: "photo")) {
        self.loader = UserIconLoader()
        self.placeholder = placeholder
        loader.load(from: path)
    }
    
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
            
        } else {
            placeholder
        }
    }
}

//struct UserIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        UserIcon()
//    }
//}
