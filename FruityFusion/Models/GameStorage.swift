//  GameStorage.swift

import Foundation

/// 中断したゲームの保存データ
struct SavedGame: Codable {
    var board: GameBoard
    var score: Int
}

/// ハイスコアと中断データの永続化を担当する
struct GameStorage {
    static let standard = GameStorage(defaults: .standard)

    let defaults: UserDefaults

    var highScore: Int {
        get { defaults.integer(forKey: StorageKey.highScore) }
        nonmutating set { defaults.set(newValue, forKey: StorageKey.highScore) }
    }

    var hasSavedGame: Bool {
        loadGame() != nil
    }

    func loadGame() -> SavedGame? {
        guard let data = defaults.data(forKey: StorageKey.savedGame) else { return nil }
        return try? JSONDecoder().decode(SavedGame.self, from: data)
    }

    func saveGame(_ game: SavedGame) {
        guard let data = try? JSONEncoder().encode(game) else { return }
        defaults.set(data, forKey: StorageKey.savedGame)
    }

    func clearSavedGame() {
        defaults.removeObject(forKey: StorageKey.savedGame)
    }
}
