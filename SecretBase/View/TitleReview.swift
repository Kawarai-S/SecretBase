//
//  TitleReview.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/16.
//

import SwiftUI

struct TitleReview: View {
    var body: some View {
        ScrollView{
            TitleDetail()
            
            VStack(alignment: .leading)  {
                HStack{
                    UserIconSmall()
                        .frame(width: 50)
                    Text("飛田")
                }
                Text("古参乙女ゲーマーとしては悪役令嬢なんてものほぼおらんわ！という気持ちから悪役令嬢モノは避けてきたが、これは本当に面白い。エミを思うレミリアの強かさに惚れる。絵も巧みで、少女漫画のような花のような笑顔を見せたかと思えば、H×Hを彷彿とさせる恐ろしげな表情が描かれる。美しく賢く強かな少女がお好きな方におすすめしたい。")
                    .lineSpacing(8)
                
                HStack {
                    Spacer()
                    Image(systemName: "star.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct TitleReview_Previews: PreviewProvider {
    static var previews: some View {
        TitleReview()
    }
}
