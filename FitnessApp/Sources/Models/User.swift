import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let fullName: String
    let email: String
    var profileImageUrl: String?
    var height: Double?
    var weight: Double?
    var fitnessGoals: [String]?
    var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName
        case email
        case profileImageUrl
        case height
        case weight
        case fitnessGoals
        case createdAt
    }
} 