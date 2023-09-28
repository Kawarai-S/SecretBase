//
//  Shelf.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Shelf: View {
    @ObservedObject private var userProfileModel = UserProfileModel()
    @ObservedObject private var authStateManager = FirebaseAuthStateManager.shared
    @State private var showProfileModal: Bool = false
    @State private var isLoading: Bool = true  // データのローディング状態を追加
    
    private var shouldShowProfilePrompt: Bool {
        return userProfileModel.user == nil
    }
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Now Loading...")  // ローディング中のテキスト
                    .font(.headline)
                    .padding(.top, 20)
            } else {
                HStack {
                    Button {
                        // 作品を追加するアクション
                    } label: {
                        Image(systemName: "plus.square")
                        Text("作品を追加する")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showProfileModal = true
                    }) {
                        HStack {
                            Text(userProfileModel.user?.name ?? "Loading...")
                            if let user = userProfileModel.user {
                                UserIcon(path: user.icon)
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                if shouldShowProfilePrompt {
                    VStack {
                        Text("まずはプロフィールを作成しましょう！")
                            .font(.headline)
                            .padding(.top, 20)
                        
                        NavigationLink(destination: AdditionalInfoView()) {
                            Text("プロフィールを作成する")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.vertical, 20)
                    }
                } else {
                    TitleView(user: userProfileModel.user ?? .dummy)
                    // Profileモーダルの表示
                        .sheet(isPresented: $showProfileModal) {
                            Profile(userId: authStateManager.currentUser?.uid ?? "")
                        }
                }
            }
        }
        .onAppear {
            if let currentUser = authStateManager.currentUser {
                userProfileModel.fetchUserData(for: currentUser.uid) {
                    self.isLoading = false  // データが読み込まれたら、ローディングを終了
                }
            } else {
                print("No current user found in onAppear.")
                self.isLoading = false  // ユーザーが見つからない場合もローディングを終了
            }
        }
    }
}

struct Shelf_Previews: PreviewProvider {
    static var previews: some View {
        Shelf()
            .environmentObject(UserProfileModel())
    }
}


