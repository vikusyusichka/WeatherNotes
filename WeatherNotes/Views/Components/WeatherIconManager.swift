import SwiftUI

enum WeatherIconMapper {
    static func sfSymbolName(for iconCode: String) -> String {
        let isNight = iconCode.hasSuffix("n")
        let code = String(iconCode.prefix(2))

        switch code {
        case "01": return isNight ? "moon.stars" : "sun.max"  
        case "02": return isNight ? "cloud.moon"  : "cloud.sun"
        case "03": return "cloud"
        case "04": return "cloud.fill"
        case "09": return "cloud.heavyrain"
        case "10": return "cloud.rain"
        case "11": return "cloud.bolt.rain"
        case "13": return "snowflake"
        case "50": return "cloud.fog"
        default:   return "cloud"
        }
    }
}

struct WeatherIconView: View {
    @Environment(\.colorScheme) private var colorScheme

    let iconCode: String
    var size: CGFloat = 28

    var body: some View {
        if colorScheme == .light {
            Image(systemName: WeatherIconMapper.sfSymbolName(for: iconCode))
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary)
        } else {
            let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure:
                    Image(systemName: "cloud")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: size, height: size)
        }
    }
}

