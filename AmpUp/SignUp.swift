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
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 16) {
                    // Consider adding a logo or title similar to ContentView, if applicable
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .bold()
                        .font(.title)
                        .padding(.bottom,20)
                    
                    // User information fields
                    InputFieldView(data: $viewModel.name, title: "Name")
                        .autocapitalization(.none)

                    InputFieldView(data: $viewModel.username, title: "Username")
                        .autocapitalization(.none)

                    InputFieldView(data: $viewModel.email, title: "Email")
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.bottom,30)

                    SecureInputFieldView(data: $viewModel.password, title: "Password")
                    
                    SecureInputFieldView(data: $viewModel.confirmPassword, title: "Confirm Password")
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    

                    Button("Sign Up") {
                        viewModel.handleSignUp()
                    }
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 182/255, green: 4/255, blue: 42/255))
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding(.top, 16)
                }
                .padding()
            }
        }
        .navigationBarTitle("Sign Up", displayMode: .inline)
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
