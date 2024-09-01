
import Alamofire
import Foundation
import SwiftUI
import CoreLocation

final class NetworkManager: ObservableObject {
    
    private let openAiToken = "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"
    private let openAiBaseURL = "https://api.openai.com/v1/images/generations"
    
    private let openWeatherToken = "4fce57cc51e5ad18a9012ca9c7c066dd"
    private let openWeatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    
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
            AF.request(openAiBaseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let responseDict = value as? [String: Any],
                           let dataArray = responseDict["data"] as? [[String: Any]],
                           let imageUrl = dataArray.first?["url"] as? String {
                            continuation.resume(returning: imageUrl)
                        } else {
                            continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"]))
                        }
                    case .failure(let error):
                        continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
                    }
                }
        }
    }
    
    func getWeather(for coordinate: CLLocationCoordinate2D) async throws -> WeatherResponse {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        
        let parameters: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "appid": openWeatherToken,
            "units": "metric"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(openWeatherBaseURL, method: .get, parameters: parameters).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        continuation.resume(returning: weatherResponse)
                    } catch let error {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
