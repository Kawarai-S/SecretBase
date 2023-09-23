//
//  ProfileEditor.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import SwiftUI

struct ProfileEditor: View {
    var user: AppUser 
    
    init(user: AppUser) {
        self.user = user
    }
    var body: some View {
        Text(user.name)
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        let dummyUser = AppUser(id: "123", name: "Sample User", icon: "sampleIconURL", profile: "Sample Profile", shelf: [])
        
        ProfileEditor(user: dummyUser)
    }
}
