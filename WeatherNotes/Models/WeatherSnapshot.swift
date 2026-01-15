import Foundation

struct WeatherSnapshot: Codable, Equatable {
    let temperatureC: Double
    let description: String
    let iconCode: String
    let locationName: String
}
