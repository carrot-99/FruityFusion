//  GameOverView.swift

import SwiftUI

struct GameOverView: View {
    let score: ScoreManager
    let bestFruit: FruitType
    let canUndo: Bool
    let onRetry: () -> Void
    let onUndo: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("ゲームオーバー")
                    .font(Theme.roundedFont(.largeTitle, weight: .heavy))
                    .foregroundColor(Theme.neutral)

                if score.isNewRecord {
                    Label("ハイスコア更新！", systemImage: "crown.fill")
                        .font(Theme.roundedFont(.headline))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Theme.secondary))
                }

                HStack(spacing: 12) {
                    ScoreView(title: "スコア", value: score.current)
                    ScoreView(title: "ベスト", value: score.best)
                }

                HStack(spacing: 10) {
                    Image(bestFruit.imageName)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    VStack(alignment: .leading) {
                        Text("到達した果物")
                            .font(Theme.roundedFont(.caption, weight: .semibold))
                            .foregroundColor(.secondary)
                        Text(bestFruit.displayName)
                            .font(Theme.roundedFont(.title3))
                            .foregroundColor(.primary)
                    }
                }

                VStack(spacing: 10) {
                    Button(action: onRetry) {
                        Label("もう一度あそぶ", systemImage: "arrow.clockwise")
                    }
                    .buttonStyle(GameButtonStyle(color: Theme.primary))

                    if canUndo {
                        Button(action: onUndo) {
                            Label("1手もどす", systemImage: "arrow.uturn.backward")
                        }
                        .buttonStyle(GameButtonStyle(color: Theme.secondary))
                    }

                    Button(action: onHome) {
                        Label("タイトルへ", systemImage: "house.fill")
                    }
                    .buttonStyle(GameButtonStyle(color: Theme.neutral))
                }
            }
            .padding(24)
            .frame(maxWidth: 380)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .padding(28)
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(
            score: ScoreManager(current: 1200, best: 1000),
            bestFruit: .apple,
            canUndo: true,
            onRetry: {}, onUndo: {}, onHome: {}
        )
    }
}
