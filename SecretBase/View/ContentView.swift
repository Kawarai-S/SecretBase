//
//  ContentView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var authStateManager = FirebaseAuthStateManager.shared
    var body: some View {
        if authStateManager.signInState {
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
        } else {
            SignInVIew()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

