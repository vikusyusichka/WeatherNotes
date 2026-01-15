import Foundation

protocol NetworkClientProtocol {
    func data(from request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

final class NetworkClient: NetworkClientProtocol {
    func data(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw WeatherError.badResponse(statusCode: -1)
            }
            return (data, http)
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                throw WeatherError.noInternet
            default:
                throw WeatherError.unknown(urlError)
            }
        } catch {
            throw WeatherError.unknown(error)
        }
    }
}

