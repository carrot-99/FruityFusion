//  TileView.swift

import SwiftUI

struct TileView: View {
    let tile: FruitTile
    @State private var popScale: CGFloat = 1

    var body: some View {
        GeometryReader { geometry in
            let side = geometry.size.width
            ZStack {
                RoundedRectangle(cornerRadius: side * 0.16, style: .continuous)
                    .fill(tile.fruit.tileColor)

                Image(tile.fruit.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: side * 0.9, height: side * 0.9)
                    .clipShape(RoundedRectangle(cornerRadius: side * tile.fruit.cornerRatio, style: .continuous))
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(popScale)
        .onAppear {
            guard tile.isMerged else { return }
            // 合体したタイルは少し弾ませる
            popScale = 1.18
            withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                popScale = 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel(tile.fruit.displayName)
    }
}

extension FruitType {
    /// タイル背景色
    var tileColor: Color {
        switch self {
        case .cherry: return Color(red: 1.00, green: 0.80, blue: 0.82)
        case .strawberry: return Color(red: 1.00, green: 0.72, blue: 0.76)
        case .grape: return Color(red: 0.82, green: 0.74, blue: 0.95)
        case .dekopon: return Color(red: 1.00, green: 0.84, blue: 0.60)
        case .persimmon: return Color(red: 1.00, green: 0.76, blue: 0.55)
        case .apple: return Color(red: 1.00, green: 0.65, blue: 0.62)
        case .pear: return Color(red: 0.92, green: 0.95, blue: 0.70)
        case .pineapple: return Color(red: 1.00, green: 0.92, blue: 0.55)
        case .peach: return Color(red: 1.00, green: 0.80, blue: 0.75)
        case .melon: return Color(red: 0.78, green: 0.93, blue: 0.70)
        case .watermelon: return Color(red: 0.62, green: 0.88, blue: 0.62)
        }
    }

    /// 画像ごとに角丸の具合が違うため、それに合わせた切り抜きの比率
    var cornerRatio: CGFloat {
        switch self {
        case .dekopon: return 0.15
        case .melon: return 0.16
        case .strawberry, .peach, .pear: return 0.19
        case .cherry, .grape, .apple, .pineapple: return 0.21
        case .watermelon: return 0.23
        case .persimmon: return 0.32
        }
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(tile: FruitTile(fruit: .apple))
            .frame(width: 100)
    }
}
