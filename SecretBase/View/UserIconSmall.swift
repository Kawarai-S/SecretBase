//
//  UserIconSmall.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/15.
//

import SwiftUI

struct UserIconSmall: View {
    
    var body: some View {
        Image("default_usericon")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            
            
    }
}

struct UserIconSmall_Previews: PreviewProvider {
    static var previews: some View {
        UserIconSmall()
    }
}
