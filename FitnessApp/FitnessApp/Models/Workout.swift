import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Workout: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var date: Date
    var exercises: [String] // Lista simple de nombres de ejercicios
    var userId: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, date, exercises, userId
    }
} 
