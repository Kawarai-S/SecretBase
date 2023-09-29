//
//  ContentView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var authStateManager = FirebaseAuthStateManager.shared
    @ObservedObject private var userProfileModel = UserProfileModel()  

    var body: some View {
        Group {
            if authStateManager.didSignInSuccessfully || authStateManager.signInState {
                //メインコンテンツ
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
                    .background(Color.white.ignoresSafeArea())
                    .tabItem {
                        Label("Serch", systemImage: "magnifyingglass")
                    }
                    
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
                        Text("自分のお気に入りレビューとか")
                            .navigationBarHidden(true)
                    }
                    .background(Color.white.ignoresSafeArea())
                    .tabItem {
                        Label("Bookmark", systemImage: "bookmark.fill")
                    }
                }
                .environmentObject(userProfileModel)  // ← 2. TabView全体にUserProfileModelを提供
            } else {
                SignInView()
            }
        }
        .onChange(of: authStateManager.didSignInSuccessfully) { newValue in
            if newValue {
                authStateManager.didSignInSuccessfully = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

