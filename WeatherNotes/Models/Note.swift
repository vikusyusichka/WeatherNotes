import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let createdAt: Date
    let weather: WeatherSnapshot
}

