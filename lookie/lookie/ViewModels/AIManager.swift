
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
                
                let dominantColor = self.dominantColor(in: image) ?? "Unknown color"
                                
                let tags = labels.map { $0.text }.joined(separator: ", ")
                let result = "\(tags), Dominant Color: (\(dominantColor))"
                
                continuation.resume(returning: result)
            }
        }
    }
    
    private func dominantColor(in image: UIImage) -> String? {
        guard let cgImage = image.cgImage else { return nil }
        let width = 1
        let height = 1
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelData = context?.data else { return nil }
        
        let data = pixelData.bindMemory(to: UInt8.self, capacity: width * height * 4)
        let r = CGFloat(data[0]) / 255.0
        let g = CGFloat(data[1]) / 255.0
        let b = CGFloat(data[2]) / 255.0
        
        return String(format: "R: %.0f G: %.0f B: %.0f", r * 255, g * 255, b * 255)
    }
        
}
