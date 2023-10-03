//
//  ReviewInputView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/26.
//

import SwiftUI

struct ReviewInputView: View {
    @State private var reviewText: String = "ここにレビューを書いてください。"
    @State private var currentAlertType: ReviewAlertType?
    @Environment(\.presentationMode) var presentationMode
    
    var itemId: String
    var isEditing: Bool
    
    // 追加・編集時に元のレビュー内容をreviewTextに渡す
    init(itemId: String, isEditing: Bool, originalReview: String? = nil) {
        self.itemId = itemId
        self.isEditing = isEditing
        if let original = originalReview {
            _reviewText = State(initialValue: original)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextEditor(text: $reviewText)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5.0).stroke(Color.gray, lineWidth: 1))
                .background(Color.white)
                .cornerRadius(5.0)
                .frame(height: 200)
                .onTapGesture {
                    if reviewText == "ここにレビューを書いてください。" {
                        reviewText = "" // タップ時に初期値をクリア
                    }
                }
                .padding(.horizontal)
            
            Button(action: {
                if isEditing {
                    updateReview(for: self.itemId, reviewText: self.reviewText) { alertType in
                        handleAlert(alertType)
                    }
                } else {
                    submitReview(for: self.itemId, reviewText: self.reviewText) { alertType in
                        handleAlert(alertType)
                    }
                }
            }) {
                Text(isEditing ? "レビューを追加・更新する" : "レビューを登録する")
                    .modifier(MainButtonModifier())
                    .padding()
            }
            .alert(item: $currentAlertType) { alertType in
                switch alertType {
                case .success:
                    return Alert(title: Text("登録完了"), message: Text("レビューが正常に登録されました。"), dismissButton: .default(Text("OK"), action: { self.dismissView() }))
                case .error:
                    return Alert(title: Text("エラー"), message: Text("レビューの登録中に問題が発生しました。"), dismissButton: .default(Text("再試行")))
                }
            }
        }
    }
    
    private func handleAlert(_ alertType: ReviewAlertType) {
        self.currentAlertType = alertType
    }
    
    func dismissView() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct ReviewInputView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewInputView(itemId: "sampleItemId", isEditing: true)
    }
}

