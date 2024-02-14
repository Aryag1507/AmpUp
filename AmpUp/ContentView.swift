//
//  ContentView.swift
//  AmpUp
//
//  Created by Keegan Reynolds on 2/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    NavigationLink(destination: Profile()) {
                        Text("My Profile")
                            .padding()
                    }
                    NavigationLink(destination: Login()) {
                        Text("Log in")
                            .padding()
                    }
                    NavigationLink(destination: Signup()) {
                        Text("Sign up")
                            .padding()
                    }
                }
                
                Text("Welcome to AmpUp!")
                    .padding()
                    .font(.title)
                NavigationLink(destination: Workouts()) {
                    Text("Create Workout")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.init(red: 0.3, green: 0.3, blue: 0.9))
                        .cornerRadius(8)
                }
                Spacer()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
