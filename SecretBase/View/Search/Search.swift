//
//  Search.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Search: View {
    @ObservedObject private var viewModel = TitleListModel()
    @State private var keyword: String = ""
    @State private var selectedCategory: Title.Category?
    @State private var imageLoaders: [String: TitleImageLoader] = [:]
    
    var filteredTitles: [Title] {
        let lowercasedKeyword = keyword.lowercased()
        return viewModel.titles.filter { title in
            (keyword.isEmpty || title.title.lowercased().contains(lowercasedKeyword)) &&
            (selectedCategory == nil || title.category == selectedCategory)
        }
    }
    
    private func imageLoader(for title: Title) -> TitleImageLoader {
        if let loader = imageLoaders[title.id] {
            return loader
        }
        let loader = TitleImageLoader()
        DispatchQueue.main.async {
            self.imageLoaders[title.id] = loader
        }
        return loader
    }
    
    var body: some View {
        VStack {
            TextField("キーワードを入力", text: $keyword)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)
            
            Picker("カテゴリ", selection: $selectedCategory) {
                Text("すべて").tag(Title.Category?.none)
                ForEach(Title.Category.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(Optional(category))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            List(filteredTitles, id: \.id) { title in
                NavigationLink(destination: SearchTitleView(title: title)) {
                    HStack {
                        let loader = self.imageLoader(for: title)
                        if let uiImage = loader.image {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 80)
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: 60, height: 80)
                        }
                        Text(title.title)
                    }
                    .onAppear {
                        self.imageLoader(for: title).load(from: title.image)
                    }
                }
            }
            .listStyle(.inset)
        }
        .onAppear {
            viewModel.fetchData()  // ビューが表示されるときにデータを取得する
        }
    }
}


struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
