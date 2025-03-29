import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var profileImageUrl: String?
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case profileImageUrl
        case createdAt
    }
    
    var isCurrentUser: Bool {
        return AuthViewModel.shared.userSession?.uid == id
    }
} 