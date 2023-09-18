//
//  Shelf.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Shelf: View {
    var user: User
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    
                } label: {
                    Image(systemName: "plus.square")
                    Text("作品を追加する")
                }

                Spacer()
                Text(user.name)
                UserIconSmall(user: user)
                    .frame(width: 48)
            }
            .padding(.horizontal)
            
            TitleView(user: user)
        }
    }
}

struct Shelf_Previews: PreviewProvider {
    static var previews: some View {
        Shelf(user: users["1001"]!)
    }
}
