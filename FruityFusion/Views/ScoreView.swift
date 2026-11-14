//  ScoreView.swift

import SwiftUI

/// スコア / ベスト表示のカード
struct ScoreView: View {
    let title: String
    let value: Int
    var popup: ScorePopup? = nil

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(Theme.roundedFont(.caption))
                .foregroundColor(.white.opacity(0.9))
            Text("\(value)")
                .font(Theme.roundedFont(.title2, weight: .heavy))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .monospacedDigit()
        }
        .frame(minWidth: 88)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Theme.scoreCard)
                .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
        )
        .overlay(alignment: .top) {
            if let popup {
                FloatingPoints(points: popup.points)
                    .id(popup.id)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) \(value)")
    }
}

/// 「+N」がふわっと上に消えていく表示
private struct FloatingPoints: View {
    let points: Int
    @State private var isAnimating = false

    var body: some View {
        Text("+\(points)")
            .font(Theme.roundedFont(.headline, weight: .heavy))
            .foregroundColor(Theme.primary)
            .shadow(color: .white, radius: 2)
            .offset(y: isAnimating ? -34 : -8)
            .opacity(isAnimating ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 0.7)) {
                    isAnimating = true
                }
            }
            .allowsHitTesting(false)
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ScoreView(title: "スコア", value: 128)
            ScoreView(title: "ベスト", value: 4096)
        }
    }
}
