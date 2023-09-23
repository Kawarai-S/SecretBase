//
//  MainView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                Shelf()
                    .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea()) // 背景色の設定
            .tabItem {
                Label("My Shelf", systemImage: "books.vertical")
            }
            
            NavigationView {
                Serch()
                    .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea()) // 背景色の設定
            .tabItem {
                Label("Serch", systemImage: "magnifyingglass")
            }
            
            NavigationView {
                Text("通知とか")
                    .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea()) // 背景色の設定
            .tabItem {
                Label("Notification", systemImage: "bell.fill")
            }
            
            NavigationView {
                Text("自分のお気に入りレビューとか")
                    .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea()) // 背景色の設定
            .tabItem {
                Label("Bookmark", systemImage: "bookmark.fill")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
