import Foundation

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherSnapshot
}

final class WeatherService: WeatherServiceProtocol {

    private let apiKey: String
    private let network: NetworkClientProtocol

    init(apiKey: String, network: NetworkClientProtocol = NetworkClient()) {
        self.apiKey = apiKey
        self.network = network
    }

    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherSnapshot {
        guard var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather") else {
            throw WeatherError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")
        ]

        guard let url = components.url else { throw WeatherError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 15

        let (data, response) = try await network.data(from: request)

        guard (200...299).contains(response.statusCode) else {
            throw WeatherError.badResponse(statusCode: response.statusCode)
        }

        do {
            let dto = try JSONDecoder().decode(OpenWeatherResponseDTO.self, from: data)
            guard let first = dto.weather.first else {
                throw WeatherError.decodingFailed
            }

            return WeatherSnapshot(
                temperatureC: dto.main.temp,
                description: first.description,
                iconCode: first.icon,
                locationName: dto.name
            )
        } catch is DecodingError {
            throw WeatherError.decodingFailed
        } catch {
            throw WeatherError.unknown(error)
        }
    }
}
