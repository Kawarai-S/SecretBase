//
//  Serch.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Serch: View {
    @State private var keyword: String = ""
    @State private var selectedCategory: Title.Category?
    
    var filteredTitles:[Title]{
        return titles.values.filter { title in
            (keyword.isEmpty || title.title.contains(keyword)) && (selectedCategory == nil || title.category == selectedCategory)
        }
    }
    var body: some View {
        NavigationView{
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
                    NavigationLink(destination: SerchTitleView(title:title)){
                        HStack{
                            Image(title.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 80)
                            Text(title.title)
                        }
                    }
                        
                }
                .listStyle(.inset)
            }
        }
    }
}

struct Serch_Previews: PreviewProvider {
    static var previews: some View {
        Serch()
    }
}
