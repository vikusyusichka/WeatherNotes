import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case noInternet
    case badResponse(statusCode: Int)
    case decodingFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noInternet:
            return "No internet connection."
        case .badResponse(let code):
            return "Bad server response (code \(code))."
        case .decodingFailed:
            return "Failed to decode weather data."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

