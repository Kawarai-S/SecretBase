//
//  Users.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/17.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let icon: String
    let profile: String
    let shelf: [ShelfItem]
}

struct ShelfItem: Codable {
    let itemId: String
    let review: String
    let isRegistered: Bool
    let likes: [Like]
}

struct Like: Codable {
    let userId: String
}
