//
//  Titles.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/15.
//

import Foundation
import SwiftUI

public struct Title: Codable {
    let id: String
    let title: String
    let category: Category
    let image: String
    let details: CategoryDetails
    
    enum Category: String, Codable {
        case manga = "マンガ"
        case game = "ゲーム"
        case anime = "アニメ"
    }
    
    enum CategoryDetails: Codable {
        case manga(MangaDetails)
        case game(GameDetails)
        case anime(AnimeDetails)
        
        struct MangaDetails: Codable {
            let author: String
            let publisherName: String
            let salesDate: String
        }
        
        struct GameDetails: Codable {
            let label: String
            let hardware: String
            let salesDate: String
        }
        
        struct AnimeDetails: Codable {
            let label: String
            let broadcastDate: String
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let mangaDetails = try? container.decode(MangaDetails.self) {
                self = .manga(mangaDetails)
                return
            }
            
            if let gameDetails = try? container.decode(GameDetails.self) {
                self = .game(gameDetails)
                return
            }
            
            if let animeDetails = try? container.decode(AnimeDetails.self) {
                self = .anime(animeDetails)
                return
            }
            
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode category details")
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .manga(let details):
                try container.encode(details)
            case .game(let details):
                try container.encode(details)
            case .anime(let details):
                try container.encode(details)
            }
        }
    }
}
