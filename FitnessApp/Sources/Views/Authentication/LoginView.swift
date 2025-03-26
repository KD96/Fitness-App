import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showRegistration = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo and Title
                VStack(spacing: 20) {
                    Image(systemName: "figure.run.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    Text("Welcome to FitnessApp")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 50)
                
                // Login Form
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.password)
                    
                    Button(action: {
                        Task {
                            try await authViewModel.signIn(withEmail: email, password: password)
                        }
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showRegistration = true
                    }) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .sheet(isPresented: $showRegistration) {
                RegistrationView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
} 