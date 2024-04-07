import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SignupViewModel: ObservableObject {
    @Published var appState: AppState
    private var authService: AuthProtocol
    private var firestoreService: FirestoreServiceProtocol
    
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    
    init(authService: AuthProtocol, firestoreService: FirestoreServiceProtocol, appState: AppState) {
        self.authService = authService
        self.firestoreService = firestoreService
        self.appState = appState
    }
    
    func handleSignUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        authService.createUser(withEmail: email, password: password) { success, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            if success {
                let userData: [String: Any] = [
                    "name": self.name,
                    "workouts": [],
                    "emg_output": []
                ]
                
                self.firestoreService.setData(for: self.username, in: "users", data: userData) { error in
                    if let error = error {
                        self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    } else {
                        DispatchQueue.main.async {
                            self.appState.isLoggedIn = true
                        }
                    }
                }
            }
        }
    }
}

struct Signup: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: SignupViewModel
    
    init(authService: AuthProtocol, firestoreService: FirestoreServiceProtocol, appState: AppState) {
        _viewModel = ObservedObject(wrappedValue: SignupViewModel(authService: authService, firestoreService: firestoreService, appState: appState))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    TextField("Name", text: $viewModel.name)
                        .autocapitalization(.none)
                    TextField("Username", text: $viewModel.username)
                        .autocapitalization(.none)
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Password")) {
                    SecureField("Password", text: $viewModel.password)
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button("Sign Up") {
                        viewModel.handleSignUp()
                    }
                }
            }
            .navigationBarTitle("Sign Up", displayMode: .inline)
        }
    }
}

// Adjusted preview provider to reflect changes
struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        let authService = AuthManager()
        let firestoreService = FirestoreService()
        let appState = AppState()
        return Signup(authService: authService, firestoreService: firestoreService, appState: appState).environmentObject(appState)
    }
}
