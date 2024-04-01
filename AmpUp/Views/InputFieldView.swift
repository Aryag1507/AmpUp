//
//  InputFieldView.swift
//  AmpUp
//
//  Created by Jack Sanchez on 3/28/24.
//

import SwiftUI

struct InputFieldView: View {
    @Binding var data: String
    var title: String?
    
    var body: some View {
        ZStack {
            Color.black // Set the background color of the ZStack to black
                .frame(height: 42)
                .cornerRadius(4)
            TextField("", text: $data)
                .padding(.horizontal, 10)
                .foregroundColor(.white) // Set text color to white
                .frame(height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .disableAutocorrection(true)
                .autocapitalization(.none)
            HStack {
                Text(title ?? "Input")
                    .font(.headline)
                    .fontWeight(.thin)
                    .foregroundColor(.white) // Set text color to white
                    .multilineTextAlignment(.leading)
                    .padding(4)
                Spacer()
            }
            .padding(.leading, 8)
            .offset(CGSize(width: 0, height: -20))
        }
        .padding(4)
    }
}

//struct InputFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputFieldView(data: <#Binding<String>#>).environmentObject(AppState())
//    }
//}
