//  Theme.swift

import SwiftUI

/// アプリ全体で使う色とスタイル
enum Theme {
    static let primary = Color(red: 0.30, green: 0.70, blue: 0.40)
    static let secondary = Color(red: 0.95, green: 0.55, blue: 0.25)
    static let neutral = Color(red: 0.55, green: 0.42, blue: 0.32)
    static let boardBackground = Color(red: 0.62, green: 0.50, blue: 0.40).opacity(0.85)
    static let emptyCell = Color.white.opacity(0.35)
    static let scoreCard = Color(red: 0.98, green: 0.62, blue: 0.22)

    /// 背景画像が無い場合のフォールバック
    static let backgroundGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.95, blue: 0.80), Color(red: 0.85, green: 0.95, blue: 0.80)],
        startPoint: .top,
        endPoint: .bottom
    )

    static func roundedFont(_ style: Font.TextStyle, weight: Font.Weight = .bold) -> Font {
        .system(style, design: .rounded).weight(weight)
    }
}

/// 押すと少し縮む、角丸の大きなボタン
struct GameButtonStyle: ButtonStyle {
    var color: Color = Theme.primary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.roundedFont(.headline))
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color)
                    .shadow(color: .black.opacity(0.2), radius: configuration.isPressed ? 1 : 4, y: configuration.isPressed ? 1 : 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.6), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// 丸いアイコンボタン
struct IconButtonStyle: ButtonStyle {
    var color: Color = Theme.neutral
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 46, height: 46)
            .background(Circle().fill(color).shadow(color: .black.opacity(0.2), radius: 3, y: 2))
            .opacity(isEnabled ? 1 : 0.4)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// 背景画像（読み込めない場合はグラデーション）
struct ScreenBackground: View {
    let imageName: String

    var body: some View {
        // overlay にすることで、scaledToFill した画像が親のレイアウト幅を押し広げないようにする
        Theme.backgroundGradient
            .overlay {
                if UIImage(named: imageName) != nil {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                }
            }
            .clipped()
            .ignoresSafeArea()
    }
}
