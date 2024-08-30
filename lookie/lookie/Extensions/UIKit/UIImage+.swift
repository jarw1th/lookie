
import UIKit
import CoreML

extension UIImage {
    
    public func convertToMultiArray() -> MLMultiArray? {
        guard let cgImage = self.cgImage else {
            print("Failed to get CGImage from UIImage.")
            return nil
        }

        let width = 320
        let height = 240
        let channels = 3

        // Create an MLMultiArray with the correct dimensions
        guard let array = try? MLMultiArray(shape: [1, NSNumber(value: height), NSNumber(value: width), NSNumber(value: channels)], dataType: .float32) else {
            print("Failed to create MLMultiArray.")
            return nil
        }

        let ciImage = CIImage(cgImage: cgImage)
        let resizedImage = ciImage.transformed(by: CGAffineTransform(scaleX: CGFloat(width) / ciImage.extent.width, y: CGFloat(height) / ciImage.extent.height))

        let context = CIContext()
        guard let pixelBuffer = context.createCGImage(resizedImage, from: CGRect(origin: .zero, size: CGSize(width: width, height: height))) else {
            print("Failed to create CGImage from CIImage.")
            return nil
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerRow = width * 4
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)

        // Create a CGContext
        guard let cgContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            print("Failed to create CGContext.")
            return nil
        }

        cgContext.draw(pixelBuffer, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))

        guard let pixelData = cgContext.data else {
            print("Failed to get pixel data from CGContext.")
            return nil
        }

        let data = pixelData.bindMemory(to: UInt8.self, capacity: width * height * 4)

        // Fill MLMultiArray with image data
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * 4
                let r = Float(data[offset]) / 255.0
                let g = Float(data[offset + 1]) / 255.0
                let b = Float(data[offset + 2]) / 255.0

                array[[0, NSNumber(value: y), NSNumber(value: x), NSNumber(value: 0)]] = NSNumber(value: r)
                array[[0, NSNumber(value: y), NSNumber(value: x), NSNumber(value: 1)]] = NSNumber(value: g)
                array[[0, NSNumber(value: y), NSNumber(value: x), NSNumber(value: 2)]] = NSNumber(value: b)
            }
        }

        return array
    }
    
}
