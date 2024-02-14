//
//  SignUp.swift
//  AmpUp
//
//  Created by Maharshi Rathod on 2/14/24.
//

import SwiftUI

struct Signup: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Password")) {
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                
                Section {
                    Button("Sign Up") {
                        // Add your sign up logic here
                        print("Sign up action")
                    }
                }
            }
            .navigationBarTitle("Sign Up", displayMode: .inline)
        }
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
    }
}
