//  FruitChainView.swift

import SwiftUI

/// 進化の順番と、このゲームでどこまで到達したかを示す
struct FruitChainView: View {
    let reached: FruitType

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("しんかの順番")
                .font(Theme.roundedFont(.caption))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Capsule().fill(Theme.neutral))

            HStack(spacing: 2) {
                ForEach(FruitType.allCases, id: \.self) { fruit in
                    let isReached = fruit.level <= reached.level
                    Image(fruit.imageName)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                        .saturation(isReached ? 1 : 0)
                        .opacity(isReached ? 1 : 0.45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color.white, lineWidth: fruit == reached ? 2.5 : 0)
                        )
                        .scaleEffect(fruit == reached ? 1.12 : 1)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: reached)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.55))
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("到達した果物: \(reached.displayName)（\(FruitType.allCases.count)段階中\(reached.level)段階）")
    }
}

struct FruitChainView_Previews: PreviewProvider {
    static var previews: some View {
        FruitChainView(reached: .pear).padding()
    }
}
