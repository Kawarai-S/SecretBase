//
//  Shelf.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/05.
//

import SwiftUI

struct Shelf: View {
    var body: some View {
        VStack{
            HStack{
                Button {
                    
                } label: {
                    Image(systemName: "plus.square")
                    Text("作品を追加する")
                }

                Spacer()
                Text("UserName")
                UserIconSmall()
                    .frame(width: 72)
            }
            .padding(.horizontal)
            ScrollView {
                ZStack{
                    Rectangle()
                        .foregroundColor(.blue)
                    VStack{
                        HStack{
                            Rectangle()
                                .frame(width: 120, height: 180)
                            Rectangle()
                                .frame(width: 120, height: 180)
                            Rectangle()
                                .frame(width: 120, height: 180)
                        }
                        .padding()
                        HStack{
                            Rectangle()
                                .frame(width: 120, height: 180)
                            Rectangle()
                                .frame(width: 120, height: 180)
                            Rectangle()
                                .frame(width: 120, height: 180)
                        }
                        .padding()
                        HStack{
                            Rectangle()
                                .frame(width: 120, height: 180)
                            Rectangle()
                                .frame(width: 120, height: 180)
                            Rectangle()
                                .frame(width: 120, height: 180)
                        }
                        .padding()
                    }
                    .foregroundColor(.white)
                    
                }
            }
          
        }
    }
}

struct Shelf_Previews: PreviewProvider {
    static var previews: some View {
        Shelf()
    }
}
