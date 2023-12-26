//  ScoreViewModel.swift

import Foundation
import SwiftUI

// スコア管理のためのViewModel
class ScoreViewModel: ObservableObject {
    // ゲームの現在スコアを監視可能なプロパティとして公開
    @Published var currentScore: Int = 0

    // スコアをリセットするメソッド
    func resetScore() {
        currentScore = 0
    }

    // タイルの合体時にスコアを加算するメソッド
    func addScore(for tile: FruitTile) {
        // タイルの種類に応じて加算するスコアを決定
        currentScore += tile.score
    }

    // スコアを特定の値で更新するメソッド（必要に応じて）
    func updateScore(to newScore: Int) {
        currentScore = newScore
    }
    
    // スコアを表示するためのフォーマット済みテキストを提供する
    var formattedScore: String {
        "スコア: \(currentScore)"
    }
}
