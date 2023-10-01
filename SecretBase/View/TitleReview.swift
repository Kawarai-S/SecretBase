//
//  TitleReview.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/16.
//

import SwiftUI

struct TitleReview: View {
    var user: AppUser
    var item: ShelfItem
    @ObservedObject var userProfileModel: UserProfileModel
    @ObservedObject private var authManager = FirebaseAuthStateManager.shared
    //Favoしてくれた人
    @State private var likedUsers: [AppUser] = []
    
    //レビュー編集モーダル表示フラグ
    @State private var showReviewModal: Bool = false
    //レビュー削除用アラートフラグ
    @State private var currentAlert: deleteAlertType?
    
    
    var titleForItem: Title? {
        return userProfileModel.titleListModel.titles.first { $0.id == item.itemId }  // ← titles の代わりに userProfileModel.titleListModel.titles を使用
    }
    
    var body: some View {
        ScrollView {
            if let title = titleForItem {
                VStack(alignment: .leading){
                    TitleDetail(title: title)
                    
                    if let review = item.review, !review.isEmpty {
                        VStack(alignment: .leading) {
                            HStack {
                                UserIcon(path: user.icon)
                                    .frame(width: 50)
                                Text(user.name)
                            }
                            Text(review)
                                .lineSpacing(8)
                            
                            HStack {
                                //なんで表示されないのー！後でまたやる
                                ForEach(likedUsers, id: \.id) { likedUser in
                                    UserIcon(path: user.icon)
                                        .frame(width: 30, height: 30)
                                }
                                Spacer()
                                if user.id != authManager.currentUser?.uid {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    //ログインユーザーのみ表示
                    if user.id == authManager.currentUser?.uid {
                        //既存のレビューがある場合
                        if !(item.review?.isEmpty ?? true) {
                            HStack{
                                Spacer()
                                Button {
                                    self.showReviewModal = true
                                } label: {
                                    Text("編集")
                                        .frame(maxWidth: 50)
                                        .padding(10)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("MainColor2"), lineWidth: 1))
                                }
                                Button {
                                    self.currentAlert = .confirmDelete
                                } label: {
                                    Text("削除")
                                        .frame(maxWidth: 50)
                                        .padding(10)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("MainColor2"), lineWidth: 1))
                                }
                                .alert(item: $currentAlert) { alertType in
                                    alertType.generateAlert(for: self.item.itemId) { success in
                                        if success {
                                            deleteReview(for: self.item.itemId) { success in
                                                if success {
                                                    currentAlert = .deleteSuccess
                                                } else {
                                                    currentAlert = .deleteError
                                                }
                                            }
                                        } else {
                                            currentAlert = .deleteError
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        } else {
                            // レビューを書いていない場合
                            Button {
                                self.showReviewModal = true
                            } label: {
                                HStack{
                                    Image(systemName: "pencil.line")
                                    Text("レビューを書く")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("MainColor2"), lineWidth: 1))
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            } else {
                Text("タイトルが見つかりません")
            }
        }
        .sheet(isPresented: $showReviewModal) {
            ReviewInputView(itemId: self.item.itemId, isEditing: true, originalReview: item.review) // itemIdを渡す
        }
        .onAppear {
            userProfileModel.loadLikedUsers(for: item.likes ?? [])
        }
    }
}



//struct TitleReview_Previews: PreviewProvider {
//    static var previews: some View {
//        // サンプルのShelfItemを取得。ここではusers["1001"]!の最初のShelfItemを使用しています。
//        if let sampleItem = users["1001"]?.shelf.first {
//            TitleReview(user: users["1001"]!, item: sampleItem)
//        } else {
//            Text("Error loading sample item.")
//        }
//    }
//}
