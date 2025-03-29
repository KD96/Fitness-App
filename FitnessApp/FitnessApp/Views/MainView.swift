import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Fitness App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image(systemName: "figure.run")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Bienvenido \(viewModel.currentUser?.username ?? "usuario")")
                    .font(.headline)
                
                Button(action: {
                    print("Comenzar")
                }) {
                    Text("Comenzar")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("Cerrar sesión")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            .padding()
            .navigationTitle("Fitness App")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthViewModel.shared)
    }
} 