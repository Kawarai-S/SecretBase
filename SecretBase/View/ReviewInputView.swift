//
//  ReviewInputView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/26.
//

import SwiftUI

struct ReviewInputView: View {
    @State private var reviewText: String = ""
    @State private var currentAlertType: ReviewAlertType?
    @Environment(\.presentationMode) var presentationMode
    var itemId: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("レビューを入力してください")
                .font(.headline)
            
            TextEditor(text: $reviewText)
                .frame(height: 200)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            Button(action: {
                submitReview(for: self.itemId, reviewText: self.reviewText) { alertType in
                    self.currentAlertType = alertType
                    if alertType == .success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }) {
                Text("レビューを登録する")
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(item: $currentAlertType) { alertType in
                switch alertType {
                case .success:
                    return Alert(title: Text("登録完了"), message: Text("レビューが正常に登録されました。"), dismissButton: .default(Text("OK")))
                case .error:
                    return Alert(title: Text("エラー"), message: Text("レビューの登録中に問題が発生しました。"), dismissButton: .default(Text("再試行")))
                }
            }
        }
    }
}



struct ReviewInputView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewInputView(itemId: "sampleItemId")
    }
}