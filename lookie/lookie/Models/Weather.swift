
import Foundation

struct WeatherResponse: Decodable {
    
    let main: Main
    let weather: [Weather]
    let name: String
    
}

struct Main: Decodable {
    
    let temp: Double
    let humidity: Int
    
}

struct Weather: Decodable {
    
    let description: String
    let main: String
    
}
