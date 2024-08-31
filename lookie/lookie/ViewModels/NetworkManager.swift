
import Alamofire
import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    
    private let openAiToken = "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"
    private let baseURL = "https://api.openai.com/v1/images/generations"
    
    func generateImage(prompt: String) async throws -> String {
        let parameters: [String: Any] = [
            "model": "dall-e-3",
            "prompt": prompt,
            "size": "1024x1024",
            "quality": "standard",
            "n": 1
        ]

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openAiToken)",
            "Content-Type": "application/json"
        ]

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print(value)
                        print(value as? [String: Any])
                        if let responseDict = value as? [String: Any],
                           let dataArray = responseDict["data"] as? [[String: Any]],
                           let imageUrl = dataArray.first?["url"] as? String {
                            continuation.resume(returning: imageUrl)
                        } else {
                            print("Invalid response data")
                            continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"]))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
                    }
                }
        }
    }
    
}
