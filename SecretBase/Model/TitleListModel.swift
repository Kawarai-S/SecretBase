//
//  FirestoreModel.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/21.
//

import Firebase
import SwiftUI

class TitleListModel: ObservableObject {
    @Published var titles: [Title] = []
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("TitleList").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.titles = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                
                guard let title = data["title"] as? String,
                      let categoryString = data["category"] as? String,
                      let image = data["image"] as? String,
                      let detailsMap = data["details"] as? [String: Any],
                      let category = Title.Category(rawValue: categoryString)
                else {
                    print("Error: Invalid data format")
                    return nil
                }
                
                var details: Title.CategoryDetails? = nil
                switch category {
                case .manga:
                    if let author = detailsMap["author"] as? String,
                       let publisherName = detailsMap["publisherName"] as? String,
                       let salesDate = detailsMap["salesDate"] as? String {
                        details = .manga(Title.CategoryDetails.MangaDetails(author: author, publisherName: publisherName, salesDate: salesDate))
                    }
                    
                case .game:
                    if let label = detailsMap["label"] as? String,
                       let hardware = detailsMap["hardware"] as? String,
                       let salesDate = detailsMap["salesDate"] as? String {
                        details = .game(Title.CategoryDetails.GameDetails(label: label, hardware: hardware, salesDate: salesDate))
                    }
                    
                case .anime:
                    if let label = detailsMap["label"] as? String,
                       let broadcastDate = detailsMap["broadcastDate"] as? String {
                        details = .anime(Title.CategoryDetails.AnimeDetails(label: label, broadcastDate: broadcastDate))
                    }
                }
                
                guard let finalDetails = details else {
                    print("Error: Details could not be parsed")
                    return nil
                }
                
                return Title(id: id, title: title, category: category, image: image, details: finalDetails)
            }
        }

    }
}
