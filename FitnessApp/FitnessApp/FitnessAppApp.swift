import SwiftUI
import Firebase

@main
struct FitnessAppApp: App {
    @StateObject var viewModel = AuthViewModel.shared
    
    init() {
        // Configurar Firebase solo si aún no se ha configurado
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
} 