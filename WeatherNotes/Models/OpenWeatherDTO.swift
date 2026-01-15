import Foundation

struct OpenWeatherResponseDTO: Decodable {
    let name: String
    let weather: [WeatherDTO]
    let main: MainDTO

    struct WeatherDTO: Decodable {
        let description: String
        let icon: String
    }

    struct MainDTO: Decodable {
        let temp: Double
    }
}

