//  TileView.swift

import Foundation
import SwiftUI

struct TileView: View {
    var tile: FruitTile?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // タイルの背景
                RoundedRectangle(cornerRadius: 10)
                    .fill(tile != nil ? Color.green : Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: geometry.size.width)

                // タイルが存在する場合
                if let tile = tile {
                    let tileFruit = tile.fruit.rawValue
                    // ビューの幅に基づいて角の丸みを計算
                    let cornerRadius = calculateCornerRadius(for: tileFruit, size: geometry.size.width)
                    
                    // 果物の画像を表示
                    Image("\(tileFruit)TileImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: tile)
        }
    }

    // 果物の種類とビューのサイズに応じた角の丸みを計算する関数
    func calculateCornerRadius(for fruit: String, size: CGFloat) -> CGFloat {
        let baseRadius: CGFloat
        switch fruit {
        case "Dekopon":
            baseRadius = 0.15
        case "Melon":
            baseRadius = 0.16
        case "Strawberry", "Peach", "Pear":
            baseRadius = 0.19
        case "Cherry", "Grape", "Apple", "Pineapple":
            baseRadius = 0.21
        case "Watermelon":
            baseRadius = 0.23
        case "Persimmon":
            baseRadius = 0.32
        default:
            baseRadius = 0.05
        }
        return size * baseRadius
    }
}
