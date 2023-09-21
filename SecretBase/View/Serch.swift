//
//  Serch.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Serch: View {
    @ObservedObject private var viewModel = TitleListViewModel()
    @State private var keyword: String = ""
    @State private var selectedCategory: Title.Category?
    
    var filteredTitles:[Title]{
        guard !keyword.isEmpty else { return [] }
        let lowercasedKeyword = keyword.lowercased()
        return viewModel.titles.filter { title in
            title.title.lowercased().contains(lowercasedKeyword) && (selectedCategory == nil || title.category == selectedCategory)
        }
    }
    
    var body: some View {
        VStack{
            TextField("キーワードを入力",text: $keyword)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)
            Picker("カテゴリ", selection: $selectedCategory) {
                Text("すべて").tag(Title.Category?.none)
                ForEach(Title.Category.allCases, id:\.self) { category in
                    Text(category.rawValue).tag(Optional(category))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            List(filteredTitles, id: \.id){ title in
                NavigationLink(destination: Text("Details")){ // 仮の遷移先
                    HStack{
                        // Image(title.image) // TODO: 画像の表示は別の方法で行う
                        Text(title.image) // 仮で画像名を表示
//                            .resizable()
//                            .scaledToFit()
                            .frame(width: 60, height: 80)
                        Text(title.title)
                    }
                }
                
            }
            .listStyle(.inset)
        }
        .onAppear() {
            viewModel.fetchData()
            // デバッグ用: データが取得できたか確認
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print(viewModel.titles)
            }
        }
    }
}

struct Serch_Previews: PreviewProvider {
    static var previews: some View {
        Serch()
    }
}

