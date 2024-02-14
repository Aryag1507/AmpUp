//
//  Login.swift
//  AmpUp
//
//  Created by Arya Gupta on 2/14/24.
//

import SwiftUI

struct Login: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
            VStack {
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding(.bottom, 42)
            VStack(spacing: 16.0){
                InputFieldView(data: $username, title: "Username")
                InputFieldView(data: $password, title: "Password")
            }.padding(.bottom, 16)
            Button(action: {}){
                Text("Log In")
                    .fontWeight(.heavy)
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.brown)
                    .foregroundColor(.white)
                    .cornerRadius(40)
            }
            HStack{
                Spacer()
                Text("Forgot Password?")
                    .fontWeight(.thin)
                    .foregroundColor(Color.blue)
                    .underline()
            }.padding(.top, 16)
        }.padding()
    }
}

struct InputFieldView: View {
    @Binding var data: String
    var title: String?
    
    var body: some View {
      ZStack {
        TextField("", text: $data)
          .padding(.horizontal, 10)
          .frame(height: 42)
          .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                .stroke(Color.gray, lineWidth: 1)
          )
        HStack {                    // HStack for the text
          Text(title ?? "Input")
            .font(.headline)
            .fontWeight(.thin)      // making the text small
            .foregroundColor(Color.gray)    // and gray
            .multilineTextAlignment(.leading)
            .padding(4)
            .background(.white)     // adding some white background
          Spacer()                  // pushing the text to the left
        }
        .padding(.leading, 8)
        .offset(CGSize(width: 0, height: -20))  // pushign the text up to overlay the border of the input field
      }.padding(4)
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
