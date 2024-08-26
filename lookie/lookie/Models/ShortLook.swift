
import Foundation
import FirebaseFirestore

struct ShortLook: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var imageUrl: String
    var isLiked: Bool
    var feedType: String
    
}
