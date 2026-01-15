import SwiftUI

enum AppTheme {
    static func pageBackground(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.black : Color(.systemGroupedBackground)
    }

    static func cardBackground(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }

    static func cardBorder(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.10) : Color.black.opacity(0.06)
    }
}

struct ThemedCard<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(12)
            .background(AppTheme.cardBackground(scheme))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(AppTheme.cardBorder(scheme), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

