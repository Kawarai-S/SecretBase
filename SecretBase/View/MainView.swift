//
//  MainView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/23.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @ObservedObject private var authStateManager = FirebaseAuthStateManager.shared
    @ObservedObject private var userProfileModel = UserProfileModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        //メインコンテンツ
        TabView(selection: $selectedTab) {
            NavigationView {
                Shelf(selectedTab: $selectedTab)
                    .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea()) // 背景色の設定
            .tabItem {
                Label("My Shelf", systemImage: "books.vertical")
            }
            .tag(0)
            
            NavigationView {
                Search()
                    .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea())
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(1)
            
            NavigationView {
                VStack {
                    Text("通知とか")
                    Button {
                        authStateManager.signOut()
                    } label: {
                        Text("SignOut")
                    }
                }
                .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea())
            .tabItem {
                Label("Notification", systemImage: "bell.fill")
            }
            
            NavigationView {
                BookmarkView()
                    .navigationBarHidden(true)
            }
            .background(Color.white.ignoresSafeArea())
            .tabItem {
                Label("Bookmark", systemImage: "bookmark.fill")
            }
        }
        .environmentObject(userProfileModel)  // ← 2. TabView全体にUserProfileModelを提供
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
