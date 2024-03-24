//
//  Profile.swift
//  AmpUp
//
//  Created by Arya Gupta on 2/14/24.
//

import SwiftUI
import UIKit
import Charts
import FirebaseAuth
//struct UserProfile {
//    var name: String
//    var age: Int
//    var gender: String
//    //    undeclared variables for userProfile struct
//}

struct Profile: View {
    @EnvironmentObject var appState: AppState
    @State private var profileName = "John Doe"
    @State private var profileImage: Image? = Image(systemName: "person.circle.fill")
    @State private var isShowingImagePicker = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Set black background for the entire page
            
            VStack(alignment: .center, spacing: 40) {
                Spacer().frame(height: 20) // Move VStack slightly down
                
                CircleImage(image: profileImage)
                    .onTapGesture {
                        isShowingImagePicker = true
                    }
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(image: $profileImage)
                    }
                
                HStack {
                    TextField("Enter your name", text: $profileName)
                        .foregroundColor(.white)
                        .font(.system(size: 36))
                    
                    Spacer().frame(width: 50) // Add spacer to adjust spacing between "John Doe" and "Edit"
                    
                    NavigationLink(destination: EditProfile(profileName: $profileName)) {
                        Text("Edit")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.gray.opacity(0))
                            .cornerRadius(1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                }
                
                NavigationLink(destination: PreviousWorkouts()) {
                    Text("My Previous Workouts")
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 182/255, green: 4/255, blue: 42/255))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                Spacer()
                Button("Sign Out") {
                    signOut()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)

                Spacer()
            }
            .padding()
        }
        
    }
    func signOut() {
                do {
                    try Auth.auth().signOut()
                    appState.isLoggedIn = false
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }
}


struct EditProfile: View {
    @Binding var profileName: String
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                TextField("Enter your new name", text: $profileName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }
        }
    }
}


struct PreviousWorkouts: View {
    var body: some View {
        ZStack { // Use ZStack to contain all views
            Color.black.edgesIgnoringSafeArea(.all)
            Text("Previous workouts here")
                .foregroundColor(.white)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

struct CircleImage: View {
    var image: Image?
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 120, height: 120)
            
            image?
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: Image?

        init(image: Binding<Image?>) {
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


// undeclared struct for user profiles, should display by user

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = UserProfile(name: "John Doe", age: 30, gender: "Male")
//        return ProfileView(userProfile: user)
//    }
//}
