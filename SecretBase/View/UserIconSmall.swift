//
//  UserIconSmall.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/15.
//

import SwiftUI

struct UserIconSmall: View {
    var user:User
    var body: some View {
        Image("\(user.icon)")
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            
            
    }
}

struct UserIconSmall_Previews: PreviewProvider {
    static var previews: some View {
        UserIconSmall(user: users["1001"]!)
    }
}
