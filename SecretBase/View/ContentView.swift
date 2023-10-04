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
    
    
    @State private var showAdditionalInfoModal: Bool = false
    @State private var showAlert = false
    @State private var userInfoExists: Bool = false
    @State private var isUserInfoUploaded = false

    
    //Shelfの「作品を追加する」ボタン用
    @State private var selectedTab: Int = 0

    var body: some View {
        Group {
            if authStateManager.didSignInSuccessfully || authStateManager.signInState {
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
                .onAppear {
                    userProfileModel.checkUserInFirestore(showAdditionalInfoModal: $showAdditionalInfoModal)
                }
                .sheet(isPresented: $showAdditionalInfoModal) {
                    AdditionalInfoView(isUploaded: $isUserInfoUploaded)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("情報が正常に保存されました"), dismissButton: .default(Text("OK")) {
                        // OKを押した後の処理
                        showAdditionalInfoModal = false
                        userProfileModel.checkUserInFirestore(showAdditionalInfoModal: $showAdditionalInfoModal)
                    })
                }
                .environmentObject(userProfileModel)
            } else {
                SignInView()
            }
        }
        .onChange(of: authStateManager.didSignInSuccessfully) { newValue in
            if newValue {
                authStateManager.didSignInSuccessfully = false
            }
        }
        .onChange(of: isUserInfoUploaded) { newValue in
            if newValue {
                showAlert = true
                showAdditionalInfoModal = false
                userProfileModel.fetchUserData()
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

