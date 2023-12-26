//  TileViewModel.swift

import Foundation
import SwiftUI

// タイルの表示と動作を管理するViewModel
class TileViewModel: ObservableObject {
    // タイルの状態を保持する
    @Published var tile: FruitTile?
    
    // タイルの初期化
    init(fruit: FruitType? = nil) {
        if let fruit = fruit {
            self.tile = FruitTile(fruit: fruit)
        }
    }
    
    // タイルの果物の種類を取得する
    var fruitType: FruitType? {
        tile?.fruit
    }
    
    // タイルのスコアを取得する
    var score: Int {
        tile?.score ?? 0
    }
    
    // タイルが空であるかどうかを確認する
    var isEmpty: Bool {
        tile == nil
    }
    
    // タイルを次の進化段階に進める
    func evolveTile() {
        tile?.evolve()
    }
    
    // 新しいタイルを生成する（ゲーム盤から呼ばれる）
    func generateNewTile() {
        if tile == nil {
            // ランダムな果物を選択し、新しいタイルを生成
            tile = FruitTile(fruit: .cherry) // または他の果物をランダムに選択
        }
    }
}

// タイルのビューに対応するための拡張機能
extension TileViewModel {
    // タイルの背景色を取得する
    var backgroundColor: Color {
        if let fruit = fruitType {
            switch fruit {
            case .cherry:
                return Color.red
            case .strawberry:
                return Color.pink
            // その他の果物に応じた色...
            default:
                return Color.green
            }
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    // タイルに表示するテキスト（スコアまたは果物の名前）を取得する
    var displayText: String {
        if let fruit = fruitType {
            return fruit.rawValue
        } else {
            return ""
        }
    }
}

