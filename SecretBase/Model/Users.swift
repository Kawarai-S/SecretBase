//
//  Users.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/17.
//

import Foundation

public struct AppUser: Codable {
    let id: String
    let name: String
    let icon: String
    let profile: String
    let shelf: [ShelfItem]
    let favorites: [String]
}

public struct ShelfItem: Codable {
    let itemId: String
    let review: String?
    let likes: [Like]?
}

public struct Like: Codable {
    let userId: String
}

extension AppUser {
    static var dummy: AppUser {
        return AppUser(
            id: "dummyID",
            name: "ダミーユーザー",
            icon: "dummyIconPath",
            profile: "",
            shelf: [],
            favorites: []
        )
    }
}
