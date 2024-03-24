//
//  ContentView.swift
//  AmpUp
//
//  Created by Keegan Reynolds on 2/12/24.
//

import FirebaseFirestore
import SwiftUI
import Firebase
import FirebaseDatabase
import Foundation

struct ContentView: View {
    @State private var names: [String] = []
    @EnvironmentObject var appState: AppState
    func loadUsers(){
        print("Firing load users")
        let db = Firestore.firestore()
        db.collection("users").getDocuments(){(snapshot, error) in
            if let error = error {
                print("error fetching docs: \(error)")
            }else {
                var fetchedUsers: [String] = []
                for doc in snapshot!.documents {
                    print("\(doc.documentID):\(doc.data())")
                    fetchedUsers.append(doc.data()["name"] as? String ?? "")
                }
                print("done fetching")
                DispatchQueue.main.async {
                    self.names = fetchedUsers
                }
            }
            
            
        }
    }
    
    func printUsers(){
        print("firing print users")
        let db = Firestore.firestore()
        db.collection("users").getDocuments(){(snapshot, error) in
            if let error = error {
                print("error fetching docs: \(error)")
            }else {
                var fetchedUsers: [String] = []
                for doc in snapshot!.documents {
                    print("\(doc.documentID):\(doc.data())")
                    fetchedUsers.append(doc.data()["name"] as? String ?? "")
                }
                print("done fetching")
                print(fetchedUsers)
            }
            
            
        }
        
    }
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    NavigationLink(destination: Profile().environmentObject(appState)) {
                        Text("My Profile")
                            .foregroundColor(.white)
                            .padding()
                    }
                    NavigationLink(destination: Login().environmentObject(appState)) {
                        Text("Log in")
                            .foregroundColor(.white)
                            .padding()
                    }
                    NavigationLink(destination: Signup().environmentObject(appState)) {
                        Text("Sign up")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                Text("Welcome to AmpUp!")
                    .foregroundColor(.white)
                    .padding()
                    .font(.title)
                
//                Text("Current Users:")
//                    .foregroundColor(.white)
//                Button("Print Current Users to console"){
//                    print("Button pressed!")
//                    printUsers()
//                }
//                List(names, id: \.self) {name in Text(name)}
//                    .onAppear{loadUsers()}
                
                NavigationLink(destination: Workouts().environmentObject(appState)) {
                    Text("Create Workout")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 182/255, green: 4/255, blue: 42/255))
                        .cornerRadius(8)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(AppState())
            ContentView().environmentObject(AppState())
        }
    }
}
