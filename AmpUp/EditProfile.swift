//
//  EditProfile.swift
//  AmpUp
//  Profile Editing Page
//  Created by Jack Sanchez on 2/14/24.
//

import SwiftUI

struct EditProfile: View {
    @State private var name: String = ""
    @State private var gender: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .padding()
            
            NavigationLink(destination: EditProfilePic()) {
                Text("Edit Profile Picture")
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            TextField("Edit Name", text: $name)
            TextField("Edit Gender", text: $gender)
            
            Spacer()
        }
        .padding()
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}

// undeclared struct for user profiles, should display by user

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = UserProfile(name: "John Doe", age: 30, gender: "Male")
//        return ProfileView(userProfile: user)
//    }
//}
