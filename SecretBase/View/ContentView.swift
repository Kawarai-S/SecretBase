//
//  ContentView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Shelf()
                .tabItem {
                    Label("My Shelf", systemImage: "books.vertical")
                }
            Serch()
                .tabItem {
                    Label("Serch", systemImage: "magnifyingglass")
                }
            
            Text("通知とか")
                .tabItem {
                    Label("Notification", systemImage: "bell.fill")
                }
            Text("自分のお気に入りレビューとか")
                .tabItem {
                    Label("Bookmark", systemImage: "bookmark.fill")
                }
                
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
