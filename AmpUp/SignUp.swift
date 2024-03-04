import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Signup: View {
    @State private var name: String = "" // Field for user's name
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String? // To display error messages

    func handleSignUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                // User signed up successfully, now add user data to Firestore with specified structure
                let db = Firestore.firestore()
                let userData: [String: Any] = [
                    "name": self.name,
                    "workouts": [], // Initialize as empty array
                    "emg_output": [] // Initialize as empty array
                ]
                
                // Use username as document ID in users collection
                db.collection("users").document(self.username).setData(userData) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                        errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    } else {
                        print("User data successfully written to Firestore with username as ID")
                        // Here, you can navigate to another view or perform other actions upon successful sign up and data save
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    TextField("Name", text: $name) // Text field for user's name
                        .autocapitalization(.none)
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
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button("Sign Up") {
                        handleSignUp()
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
