import SwiftUI

enum WeatherIconManager {
    static func sfSymbolName(for iconCode: String) -> String {
        let isNight = iconCode.hasSuffix("n")
        let code = String(iconCode.prefix(2))

        switch code {
        case "01": return isNight ? "moon.stars.fill" : "sun.max.fill"
        case "02": return isNight ? "cloud.moon.fill" : "cloud.sun.fill"
        case "03": return "cloud.fill"
        case "04": return "smoke.fill"
        case "09": return "cloud.heavyrain.fill"
        case "10": return "cloud.rain.fill"
        case "11": return "cloud.bolt.rain.fill"
        case "13": return "snowflake"
        case "50": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}

struct WeatherIconView: View {
    @Environment(\.colorScheme) private var colorScheme

    let iconCode: String
    var size: CGFloat = 28

    var body: some View {
        Image(systemName: WeatherIconManager.sfSymbolName(for: iconCode))
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(foregroundColor)
    }

    private var foregroundColor: Color {
        colorScheme == .dark ? .white : .secondary
    }
}
