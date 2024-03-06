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
                    fetchedUsers.append(doc.data()["name"] as! String )
                }
                print("done fetching")
                print(fetchedUsers)
            }
            
            
        }
        
    }
    
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
                Text("Current Users:")
                Button("Print Current Users to console"){
                    print("BUtton pressed!")
                    printUsers()
                    
                }
                List(names, id: \.self) {name in Text(name)}
                .onAppear{loadUsers()}
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
        Group {
            ContentView()
            ContentView()
        }
    }
}
