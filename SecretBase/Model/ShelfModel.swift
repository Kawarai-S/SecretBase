//
//  ShelfModel.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/10/03.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

//作品を棚に追加する
func addShelfItem(item: ShelfItem, for userId: String, completion: @escaping (Bool) -> Void) {
    let firestore = Firestore.firestore()
    let shelfRef = firestore.collection("Users").document(userId).collection("shelf")
    
    let data: [String: Any] = [
        "itemid": item.itemId,
        "review": item.review ?? "",
        "likes": item.likes?.map { ["userId": $0.userId] } ?? []
    ]
    
    shelfRef.addDocument(data: data) { error in
        if let error = error {
            print("Error adding shelf item: \(error.localizedDescription)")
            completion(false)
        } else {
            completion(true)
        }
    }
}

func addTitleToShelf(for title: Title, completion: @escaping (Bool) -> Void) {
    let shelfItem = ShelfItem(itemId: title.id, review: nil, likes: nil)
    if let currentUserId = Auth.auth().currentUser?.uid {
        addShelfItem(item: shelfItem, for: currentUserId) { success in
            completion(success)
        }
    } else {
        completion(false)
    }
}

//レビュー投稿
func submitReview(for itemId: String, reviewText: String, completion: @escaping (ReviewAlertType) -> Void) {
    let shelfItem = ShelfItem(itemId: itemId, review: reviewText, likes: nil)
    if let currentUserId = Auth.auth().currentUser?.uid {
        addShelfItem(item: shelfItem, for: currentUserId) { success in
            if success {
                completion(.success)
            } else {
                completion(.error)
            }
        }
    } else {
        completion(.error) // 失敗
    }
}

enum ReviewAlertType: Identifiable {
    case success, error
    
    var id: Int {
        switch self {
        case .success:
            return 1
        case .error:
            return 2
        }
    }
}

// レビューの追加・編集
func updateReview(for itemId: String, reviewText: String, completion: @escaping (ReviewAlertType) -> Void) {
    guard let currentUserId = Auth.auth().currentUser?.uid else {
        completion(.error)
        return
    }
    
    let firestore = Firestore.firestore()
    let shelfRef = firestore.collection("Users").document(currentUserId).collection("shelf")
    
    // itemIdを元にドキュメントを特定し、そのドキュメントのレビュー部分のみを更新します
    shelfRef.whereField("itemid", isEqualTo: itemId).getDocuments { (snapshot, error) in
        if let error = error {
            print("Error getting document: \(error.localizedDescription)")
            completion(.error)
            return
        }
        
        guard let document = snapshot?.documents.first else {
            print("Document does not exist.")
            completion(.error)
            return
        }
        
        document.reference.updateData(["review": reviewText]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completion(.error)
            } else {
                completion(.success)
            }
        }
    }
}

// レビューの削除（フィールドを空にする）
func deleteReview(for itemId: String, completion: @escaping (Bool) -> Void) {
    guard let currentUserId = Auth.auth().currentUser?.uid else {
        completion(false)
        return
    }
    
    let firestore = Firestore.firestore()
    let shelfRef = firestore.collection("Users").document(currentUserId).collection("shelf")
    
    // itemIdを元にドキュメントを特定します
    shelfRef.whereField("itemid", isEqualTo: itemId).getDocuments { (snapshot, error) in
        if let error = error {
            print("Error getting document: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        guard let document = snapshot?.documents.first else {
            print("Document does not exist.")
            completion(false)
            return
        }
        
        // ドキュメントのレビュー部分のみを空文字に更新します
        document.reference.updateData(["review": ""]) { err in
            if let err = err {
                print("Error deleting review: \(err.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}


enum deleteAlertType: Identifiable {
    case confirmDelete, deleteSuccess, deleteError
    
    var id: Int {
        switch self {
        case .confirmDelete: return 1
        case .deleteSuccess: return 2
        case .deleteError: return 3
        }
    }
}

extension deleteAlertType {
    func generateAlert(for itemId: String, with deleteAction: @escaping (Bool) -> Void) -> Alert {
        switch self {
        case .confirmDelete:
            return Alert(title: Text("レビューを削除しますか？"),
                         message: Text("この操作は取り消せません。"),
                         primaryButton: .destructive(Text("削除"), action: {
                deleteReview(for: itemId, completion: deleteAction)
            }),
                         secondaryButton: .cancel())
        case .deleteSuccess:
            return Alert(title: Text("成功"), message: Text("レビューの削除に成功しました。"), dismissButton: .default(Text("OK")))
        case .deleteError:
            return Alert(title: Text("エラー"), message: Text("レビューの削除に失敗しました。"), dismissButton: .default(Text("OK")))
        }
    }
}

