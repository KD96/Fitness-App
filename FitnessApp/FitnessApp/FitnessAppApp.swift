import SwiftUI
import Firebase

@main
struct FitnessAppApp: App {
    @StateObject var viewModel = AuthViewModel.shared
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
} 