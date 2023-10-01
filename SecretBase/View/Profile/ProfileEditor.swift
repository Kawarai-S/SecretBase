//
//  ProfileEditor.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var user: AppUser  // バインディングされたユーザーオブジェクト
    @State private var updatedName: String
    @State private var updatedProfile: String
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    init(user: AppUser) {
        _user = .constant(user)  // 初期値のセットアップ
        _updatedName = State(initialValue: user.name)
        _updatedProfile = State(initialValue: user.profile)
    }
    
    var body: some View {
        VStack {
            // アイコン画像の選択と表示
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                UserIcon(path: user.icon)
                    .frame(width: 100, height: 100)
            }
            Button("Pick Image") {
                isImagePickerPresented = true
            }
            
            // ユーザー名の編集
            TextField("Name", text: $updatedName)
                .padding()
                .border(Color.gray)
            
            // プロフィール文の編集
            TextField("Profile", text: $updatedProfile)
                .padding()
                .border(Color.gray)
            
            // 更新ボタン
            Button("Update Profile") {
                updateUserProfile(selectedImage: selectedImage, name: updatedName, profile: updatedProfile) { success in
                    if success {
                        alertMessage = "Profile updated successfully!"
                    } else {
                        alertMessage = "Failed to update profile. Please try again."
                    }
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Profile Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .sheet(isPresented: $isImagePickerPresented, content: {
            // 画像ピッカーの表示
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
        })
    }
}


struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        let dummyUser = AppUser(id: "123", name: "Sample User", icon: "sampleIconURL", profile: "Sample Profile", shelf: [])
        
        ProfileEditor(user: dummyUser)
    }
}
