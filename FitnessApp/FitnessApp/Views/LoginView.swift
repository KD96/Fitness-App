import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var username = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo
                Image(systemName: "figure.run")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                // Title
                Text(isLoginMode ? "Iniciar Sesión" : "Crear Cuenta")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Form
                VStack(spacing: 20) {
                    if !isLoginMode {
                        TextField("Usuario", text: $username)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .disabled(viewModel.isLoading)
                    }
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disabled(viewModel.isLoading)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .disabled(viewModel.isLoading)
                    
                    if let error = viewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        if isLoginMode {
                            viewModel.signIn(withEmail: email, password: password)
                        } else {
                            viewModel.register(withEmail: email, password: password, username: username)
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        } else {
                            Text(isLoginMode ? "Iniciar Sesión" : "Registrarse")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(viewModel.isLoading)
                    
                    Button(action: {
                        withAnimation {
                            isLoginMode.toggle()
                            viewModel.error = nil
                        }
                    }) {
                        Text(isLoginMode ? "¿No tienes cuenta? Regístrate" : "¿Ya tienes cuenta? Inicia sesión")
                            .foregroundColor(.blue)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel.shared)
    }
} 