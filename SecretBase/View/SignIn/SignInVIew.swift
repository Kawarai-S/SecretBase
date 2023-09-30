//
//  SignInVIew.swift
//  SecretBase
//
//  Created by 瓦井つばさ on 2023/09/22.
//

import SwiftUI

struct SignInView: View {
    @State  var isSignIn:Bool = false
    @State  var isSignUp:Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                
                Image("favo")
                    .resizable()
                    .frame(width: 250, height: 250)
                Text("My Favorite Things")
                    .foregroundColor(.white)
               
                Group{
                    Button{
                        isSignIn = true
                    } label: {
                        Text("Sign-In")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.heavy)
                            .font(.title2)
                            .cornerRadius(30)
                    }
                    .padding()
                    
                }
                .navigationDestination(isPresented: $isSignIn) {
                    SignIn()
                }
                Group{
                    Button{
                        isSignUp = true
                    } label: {
                        Text("Sign-Up")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.heavy)
                            .font(.title2)
                            .cornerRadius(30)
                    }
                    .padding()
                    
                }
                .navigationDestination(isPresented: $isSignUp) {
                    SignUp()
                }
                Spacer()
            }
            .background(Color("MainColor"))
        }
    }
}

struct SignInVIew_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
