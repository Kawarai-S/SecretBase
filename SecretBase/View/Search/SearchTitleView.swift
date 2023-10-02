//
//  SearchTitleView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/19.
//

import SwiftUI

struct SearchTitleView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var title: Title
    @ObservedObject private var viewModel: SearchTitleViewModel
    
    @State private var showingActionSheet = false
    @State private var navigateToReviewInput = false
    
    init(title: Title) {
        self.title = title
        self.viewModel = SearchTitleViewModel(title: title)
    }
    
    @ObservedObject var userProfileModel = UserProfileModel()  // ← 変更
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TitleDetail(title: title)
                
                VStack(alignment: .leading) {
                    
                    Button {
                        self.showingActionSheet = true
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.square")
                            Text("棚に作品を追加する")
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("MainColor"))
                    .foregroundColor(Color.white)
                    .fontWeight(.medium)
                    .font(.headline)
                    .cornerRadius(30)
                    .actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("選択してください"), buttons: [
                            .default(Text("登録する")) {
                                addTitleToShelf(for: self.title) { success in
                                    if success {
                                        self.alertTitle = "登録完了"
                                        self.alertMessage = "正常に登録されました。"
                                    } else {
                                        self.alertTitle = "エラー"
                                        self.alertMessage = "登録中に問題が発生しました。"
                                    }
                                    self.showAlert = true
                                }
                            },
                            .default(Text("レビューを書いて登録する")) {
                                self.navigateToReviewInput = true
                                
                            },
                            .cancel()  // キャンセルボタン
                        ])
                    }
                    //作品を棚に登録している人を表示
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(Color("SubColor2"))
                        Text("この作品を好きな人")
                    }
                    .padding(.top)
                    .fontWeight(.regular)
                    .font(.headline)
                    ForEach(viewModel.usersWithThisTitle.prefix(3), id: \.id) { user in
                        NavigationLink(destination: OtherUserShelf(userId: user.id, userProfileModel: userProfileModel, bookmarkedUsersModel: BookmarkedUsersModel())) {  // ← userProfileModelを渡す
                            HStack {
                                UserIcon(path: user.icon)
                                    .frame(width: 32, height: 32)
                                Text(user.name)
                            }
                        }
                    }
                    NavigationLink(destination: UsersListView(users: viewModel.usersWithThisTitle)) {
                        HStack {
                            Spacer()
                            HStack{
                                Image(systemName: "ellipsis.circle.fill")
                                Text("もっとみる")
                            }
                            .frame(maxWidth: 120)
                            .padding(5)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color("MainColor2"), lineWidth: 1))
                            .fontWeight(.regular)
                            .font(.headline)
                        }
                        
                        
                    }
                    
                }
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.fetchUsersWithItem()
                print("ViewModel Users: \(self.viewModel.usersWithThisTitle)")
            }
            
        }
        NavigationLink(
            destination: ReviewInputView(itemId: self.title.id, isEditing: false),
            isActive: $navigateToReviewInput
        ) {
            EmptyView()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


//struct SearchTitleView_Previews: PreviewProvider {
//    static var previews: some View {
//        if let sampleTitle = titles["013"] {
//            SearchTitleView(title: sampleTitle)
//        } else {
//            Text("Sample title not found.")
//        }
//    }
//}

