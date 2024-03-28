//
//  Login.swift
//  AmpUp
//
//  Created by Arya Gupta on 2/14/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginError: LoginError?
    @State private var isAuthenticated: Bool = false  // Track authentication state
    @State private var showingContentView: Bool = false // Track if ContentView should be shown
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        // Logo
                        Image("logoWhite")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                        
                        // Welcome text
                        Text("Welcome to AmpUp!")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title)
                        
                        ZStack{
                            VStack(spacing: 16.0){
                                InputFieldView(data: $username, title: "Email")
                                InputFieldView(data: $password, title: "Password")
                            }
                            .padding(.bottom, 16)
                            .background(Color.black)
                        }
                        .background(Color.black)
                        
                        Button(action: {
                            signIn()
                        }) {
                            Text("Log In")
                                .fontWeight(.heavy)
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 182/255, green: 4/255, blue: 42/255))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                        }
                        .alert(item: $loginError) { error in
                            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                        }
                        
                        HStack{
                            Text("Don't have an account with us?")
                                .fontWeight(.thin)
                                .foregroundColor(Color.white)
                            
                            NavigationLink(destination: Signup().environmentObject(appState)) {
                                Text("Sign up")
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }
                        .padding(.top, 16)
                    }
                }
//                .offset(y: -50)
                .padding()
                .background(Color.black)
                .navigationBarHidden(true)
                .background(
                    NavigationLink(
                        destination: ContentView(),
                        isActive: $showingContentView
                    ) {
                        EmptyView()
                    }
                )
            }
            
            .onChange(of: isAuthenticated) { newValue in
                if newValue {
                    showingContentView = true
                }
            }
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                // Handle login error
                loginError = LoginError(message: error.localizedDescription)
            } else {
                // Authentication successful
                print("sign in successful")
                DispatchQueue.main.async {
                    self.appState.isLoggedIn = true // Update app state to indicate user is logged in
                }
            }
        }
    }
}


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



struct LoginError: Identifiable {
    let id = UUID()
    let message: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
