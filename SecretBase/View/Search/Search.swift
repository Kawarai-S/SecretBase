//
//  Search.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Search: View {
    @ObservedObject private var viewModel = TitleSearchModel() // 1. ViewModelを変更
    @State private var keyword: String = ""
    @State private var selectedCategory: Title.Category?
    @State private var imageLoaders: [String: TitleImageLoader] = [:]
    
    private func imageLoader(for title: Title) -> TitleImageLoader {
        if let loader = imageLoaders[title.id] {
            return loader
        }
        let loader = TitleImageLoader()
        imageLoaders[title.id] = loader
        return loader
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("キーワードを入力", text: $keyword)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                
                Button("検索") {
                    viewModel.fetchData(matching: keyword, category: selectedCategory)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.blue)
                .cornerRadius(8)
            }.padding(.horizontal)
            
            Picker("カテゴリ", selection: $selectedCategory) {
                Text("すべて").tag(Title.Category?.none)
                ForEach(Title.Category.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(Optional(category))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            List(viewModel.titles, id: \.id) { title in
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
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
