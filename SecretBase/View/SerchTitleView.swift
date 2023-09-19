//
//  SerchTitleView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/19.
//

import SwiftUI

struct SerchTitleView: View {
    var title:Title
    
    var usersWithThisTitle: [User] {
        return users.values.filter { user in
            user.shelf.contains(where: { $0.itemId == title.id })
        }
    }
    
    var body: some View {
        ScrollView{
            VStack {
                TitleDetail(title: title)
                
                List(usersWithThisTitle, id: \.id) { user in
                    HStack {
                        Image(user.icon)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(25)
                        Text(user.name)
                    }
                }
            }
            Spacer()
        }
        
    }
}

struct SerchTitleView_Previews: PreviewProvider {
    static var previews: some View {
        if let sampleTitle = titles["021"] {
            TitleDetail(title: sampleTitle)
        } else {
            Text("Sample title not found.")
        }    }
}
