//
//  TitleSearchModel.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/25.
//

import Foundation
import FirebaseFirestore

class TitleSearchModel: ObservableObject {
    @Published var titles: [Title] = []
    @Published var allTitles: [Title] = []  // Firestoreから全件取得したデータを保持するためのプロパティ
    @Published var filteredTitles: [Title] = []
    
    private var db = Firestore.firestore()
    
    func fetchAllData() {
        db.collection("TitleList").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching titles: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.allTitles = documents.compactMap { queryDocumentSnapshot in
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
    
    // ローカルでのフィルタリングロジック
    func filterData(with keyword: String?, category: Title.Category?) {
        filteredTitles = titles.filter { title in
            let matchesKeyword = keyword?.isEmpty ?? true || title.title.contains(keyword ?? "")
            let matchesCategory = category == nil || title.category == category
            return matchesKeyword && matchesCategory
        }
    }
}
