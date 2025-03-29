import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var error: String?
    @Published var isLoading: Bool = false
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func signIn(withEmail email: String, password: String) {
        self.isLoading = true
        self.error = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            
            if let error = error {
                self.error = error.localizedDescription
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    self.error = error.localizedDescription
                    print("DEBUG: Failed to fetch user with error \(error.localizedDescription)")
                    return
                }
                
                do {
                    if let snapshot = snapshot {
                        self.currentUser = try snapshot.data(as: User.self)
                    }
                } catch {
                    self.error = "Error decoding user data"
                    print("DEBUG: Failed to decode user data: \(error)")
                }
            }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            self.error = error.localizedDescription
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func register(withEmail email: String, password: String, username: String) {
        self.isLoading = true
        self.error = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.isLoading = false
                self.error = error.localizedDescription
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { 
                self.isLoading = false
                return 
            }
            
            self.userSession = user
            
            let data = User(
                id: user.uid,
                username: username,
                email: email,
                createdAt: Date()
            )
            
            do {
                try Firestore.firestore().collection("users")
                    .document(user.uid)
                    .setData(from: data) { error in
                        self.isLoading = false
                        
                        if let error = error {
                            self.error = error.localizedDescription
                            print("DEBUG: Failed to upload user data with error \(error.localizedDescription)")
                            return
                        }
                        
                        self.fetchUser()
                    }
            } catch {
                self.isLoading = false
                self.error = error.localizedDescription
                print("DEBUG: Failed to encode user data: \(error)")
            }
        }
    }
} 
