import SwiftUI
import FirebaseCore

@main
struct FitnessAppApp: App {
    @StateObject var viewModel = AuthViewModel.shared
    private var firebaseTest: FirebaseTest?
    
    init() {
        FirebaseApp.configure()
        
        // Inicializar el test de Firebase
        firebaseTest = FirebaseTest()
        
        // Comentamos temporalmente la inicialización de AuthViewModel para aislar problemas
        // viewModel = AuthViewModel.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
} 