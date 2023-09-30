//
//  AdditionalInfoView.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/27.
//

import SwiftUI
import Firebase

struct AdditionalInfoView: View {
    @State private var name: String = ""
    @State private var profile: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
            Button("Pick Image") {
                isImagePickerPresented = true
            }
            
            TextField("Name", text: $name)
                .padding()
                .border(Color.gray)
            
            TextField("Profile", text: $profile)
                .padding()
                .border(Color.gray)
            
            Button("Complete Sign Up") {
                uploadImage(selectedImage: selectedImage, name: name, profile: profile) { success in
                    if success {
                        // 例: ContentViewに遷移するなど、成功した後の処理をここに書く
                    } else {
                        // 例: エラーアラートを表示するなど、失敗した場合の処理をここに書く
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
        })
    }
}

struct AdditionalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionalInfoView()
    }
}

