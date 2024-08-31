
import UIKit
import MLKit
import CoreML
import Vision

final class AIManager: ObservableObject {

    private var model: FashionClassifierWithSubclasses?
    
    private let primaryClassLabels = ["accessories", "bottomwear", "footwear", "one-piece", "upperwear"]
    private let subclassLabels = ["bag", "hat", "pants", "shorts", "skirt", "flats", "heels", "shoes", "sneakers", "dress", "jacket", "shirt", "tshirt"]
    
    init() {
        loadFashionClassifierModel()
    }
    
    func analyzeImage(image: UIImage) async -> String {
        let googleTags = try? await processImageLabels(image: image)
        let dominantColor = self.dominantColor(in: image) ?? "Unknown color"
        
        let classifierTags = self.classifyImageToClasses(image)
        
        let result = "\(googleTags ?? ""), \(classifierTags), Dominant Color: (\(dominantColor))"
        return result
    }
    
    private func processImageLabels(image: UIImage) async throws -> String {
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
                
                let googleTags = labels.map { $0.text }.joined(separator: ", ")
                continuation.resume(returning: googleTags)
            }
        }
    }
    
    private func loadFashionClassifierModel() {
        do {
            model = try FashionClassifierWithSubclasses(configuration: MLModelConfiguration())
        } catch {
            print("Failed to load model: \(error.localizedDescription)")
        }
    }
    
    private func classifyImageToClasses(_ image: UIImage) -> String {
        guard let model = model else {
            return "Model not loaded"
        }

        guard let multiArray = image.convertToMultiArray() else {
            return "Failed to convert image to MultiArray"
        }

        do {
            let prediction = try model.prediction(input: FashionClassifierWithSubclassesInput(input_1: multiArray))
            
            let primaryOutput = prediction.Identity
            let subclassOutput = prediction.Identity_1

            let topPrimaryLabels = getTopClassLabel(from: primaryOutput, labels: primaryClassLabels)
            let topSubclassLabels = getTopClassLabel(from: subclassOutput, labels: subclassLabels)

            return "\(topPrimaryLabels), \(topSubclassLabels)"
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
    
    private func getTopClassLabel(from multiArray: MLMultiArray, labels: [String]) -> String {
        let values = multiArray.dataPointer.bindMemory(to: Float32.self, capacity: multiArray.count)
        let count = multiArray.shape[1].intValue
        
        var indexedValues: [(index: Int, value: Float32)] = []
        for i in 0..<count {
            indexedValues.append((index: i, value: values[i]))
        }

        indexedValues.sort { $0.value > $1.value }

        guard let topIndex = indexedValues.first?.index else {
            return "Unknown"
        }
        let topLabel = labels[topIndex]

        return topLabel
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
