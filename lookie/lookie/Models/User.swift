
import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct User: Identifiable, Codable, Hashable {
    
    let id: String
    let email: String
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == id
    }
    
}

extension User {
    
    static var TEST_USER = User(id: UUID().uuidString, email: "test@gmail.com")
    
}
