//
//  Profile.swift
//  AmpUp
//
//  Created by Arya Gupta on 2/14/24.
//

import SwiftUI

//struct UserProfile {
//    var name: String
//    var age: Int
//    var gender: String
//    //    undeclared variables for userProfile struct
//}

struct Profile: View {

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .padding()
            
            Text("John Doe")
            Text("Male")
            
            NavigationLink(destination: EditProfile()) {
                Text("Edit Profile")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}

struct EditProfile: View {

    var body: some View {
        Text("Change Name");
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

// undeclared struct for user profiles, should display by user

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = UserProfile(name: "John Doe", age: 30, gender: "Male")
//        return ProfileView(userProfile: user)
//    }
//}
