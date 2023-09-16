//
//  TitleDetail.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/15.
//

import SwiftUI

struct TitleDetail: View {
    var body: some View {
        HStack {
            TitleImage()
            VStack(alignment: .leading) {
                Text("悪役令嬢の中の人〜断罪された転生者のため嘘つきヒロインに復讐いたします〜(1)")
                    .font(.title3)
                Divider()
                Text("白梅 ナズナ/まきぶろ")
                Text("一迅社")
                Text("2022年04月25日")
            }
            .padding(.leading)
            
            
        }
        .padding()
    }
}

struct TitleDetail_Previews: PreviewProvider {
    static var previews: some View {
        TitleDetail()
    }
}
