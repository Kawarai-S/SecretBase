//
//  TitleDetail.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/15.
//

import SwiftUI

struct TitleDetail: View {
    let title: Title
    
    var body: some View {
        HStack {
            SingleTitleImageView(title: title)
            VStack(alignment: .leading) {
                Text(title.title)
                    .font(.title3)
                
                switch title.category {
                case .manga:
                    if case .manga(let mangaDetails) = title.details {
                        Group {
                            Text("作者: \(mangaDetails.author)")
                            Text("出版社: \(mangaDetails.publisherName)")
                            Text("発売日: \(mangaDetails.salesDate)")
                        }
                    }
                case .game:
                    if case .game(let gameDetails) = title.details {
                        Group {
                            Text("メーカー: \(gameDetails.label)")
                            Text("ハードウェア: \(gameDetails.hardware)")
                            Text("発売日: \(gameDetails.salesDate)")
                        }
                    }
                case .anime:
                    if case .anime(let animeDetails) = title.details {
                        Group {
                            Text("製作会社: \(animeDetails.label)")
                            Text("放送日: \(animeDetails.broadcastDate)")
                        }
                    }
                }
            }
            .padding(.leading)
            
            
        }
        .padding()
    }
}

//struct TitleDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        if let sampleTitle = titles["001"] {
//            TitleDetail(title: sampleTitle)
//        } else {
//            Text("Sample title not found.")
//        }    }
//}
