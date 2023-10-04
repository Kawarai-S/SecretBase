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
    @State private var profile: String = "Enter your profile here..."
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    
    @Binding var isUploaded: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
            Button {
                isImagePickerPresented = true
            } label: {
                Image(systemName: "photo.circle.fill")
                Text("アイコンを設定")
            }
            .modifier(OverlayButtonModifier(maxWidth: 150, paddingValue: 8))
            .foregroundColor(Color("MainColor2"))
            .padding()
            
            TextField("Name", text: $name)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.gray, lineWidth: 1))
                .background(Color.white)
                .cornerRadius(5.0)
            
            TextEditor(text: $profile)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5.0).stroke(Color.gray, lineWidth: 1))
                .background(Color.white)
                .cornerRadius(5.0)
                .frame(height: 200)
                .onTapGesture {
                    if profile == "Enter your profile here..." {
                        profile = "" // タップ時に初期値をクリア
                    }
                }
            
            Button("Complete Sign Up") {
                uploadImage(selectedImage: selectedImage, name: name, profile: profile) { success in
                    if success {
                        isUploaded = true
                    } else {
                        // エラーハンドリング
                    }
                }
            }
            .modifier(MainButtonModifier())
        }
        .padding()
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
        })
    }
}

//struct AdditionalInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdditionalInfoView()
//    }
//}

