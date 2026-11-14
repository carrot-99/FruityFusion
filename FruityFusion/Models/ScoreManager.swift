//  ScoreManager.swift

import Foundation

/// 現在のスコアとハイスコアを管理する値型
struct ScoreManager: Equatable, Codable {
    private(set) var current: Int
    private(set) var best: Int
    /// このゲーム中にハイスコアを更新したか
    private(set) var isNewRecord: Bool

    init(current: Int = 0, best: Int, isNewRecord: Bool = false) {
        self.current = current
        self.best = max(best, current)
        self.isNewRecord = isNewRecord
    }

    mutating func add(_ points: Int) {
        guard points > 0 else { return }
        current += points
        if current > best {
            best = current
            isNewRecord = true
        }
    }

    mutating func reset() {
        current = 0
        isNewRecord = false
    }
}
