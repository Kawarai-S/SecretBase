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
                Text("My Favorite Things")
                    .font(.title)
                Spacer()
                Group{
                    Button{
                        isSignIn = true
                    } label: {
                        Text("Sign-In")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
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
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding()
                    
                }
                .navigationDestination(isPresented: $isSignUp) {
                    SignUp()
                }
            }
        }
    }
}

struct SignInVIew_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
