//  ScoreManager.swift

import Foundation
import SwiftUI

class ScoreManager: ObservableObject {
    @Published var currentScore: Int = 0
    @Published var highScore: Int
    
    init() {
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
    }

    func resetScore() {
        currentScore = 0
    }

    func addScore(for tile: FruitTile) {
        switch tile.fruit {
        case .cherry:
            currentScore += 2
        case .strawberry:
            currentScore += 4
        case .grape:
            currentScore += 8
        case .dekopon:
            currentScore += 16
        case .persimmon:
            currentScore += 32
        case .apple:
            currentScore += 64
        case .pear:
            currentScore += 128
        case .pineapple:
            currentScore += 256
        case .peach:
            currentScore += 512
        case .melon:
            currentScore += 1024
        case .watermelon:
            currentScore += 2048
        case .superWatermelon:
            currentScore += 4096
        }
        
        currentScore += tile.score
        
        if currentScore > highScore {
            highScore = currentScore
            // 新しいハイスコアをUserDefaultsに保存
            UserDefaults.standard.set(highScore, forKey: "HighScore")
        }
    }
}
