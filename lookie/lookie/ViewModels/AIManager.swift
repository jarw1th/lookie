
import UIKit
import MLKit

final class AIManager: ObservableObject {

    func analyzeImage(image: UIImage) async throws -> String {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        let options = ImageLabelerOptions()
        options.confidenceThreshold = 0.7
        let labeler = ImageLabeler.imageLabeler(options: options)
        return try await withCheckedThrowingContinuation { continuation in
            labeler.process(visionImage) { labels, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let labels = labels else {
                    continuation.resume(returning: "No labels found")
                    return
                }
                
                let tags = labels.map { $0.text }.joined(separator: ", ")
                continuation.resume(returning: tags)
            }
        }
    }
        
}
