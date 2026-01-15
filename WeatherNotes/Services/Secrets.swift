import Foundation

enum Secrets {
    static var openWeatherAPIKey: String {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any],
            let key = dict["OPEN_WEATHER_API_KEY"] as? String
        else {
            fatalError("OpenWeather API key not found")
        }
        return key
    }
}

