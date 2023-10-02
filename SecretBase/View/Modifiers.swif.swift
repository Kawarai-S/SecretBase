//
//  Modifiers.swif.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/10/02.
//

import Foundation
import SwiftUI

struct MainButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("MainColor"))
            .foregroundColor(Color.white)
            .fontWeight(.medium)
            .font(.headline)
            .cornerRadius(30)
    }
}

struct OverlayButtonModifier: ViewModifier {
    var maxWidth: CGFloat
    var paddingValue: CGFloat = 5  // デフォルト値として5を設定
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth)
            .padding(paddingValue)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color("MainColor2"), lineWidth: 1))
            .fontWeight(.regular)
            .font(.headline)
    }
}
