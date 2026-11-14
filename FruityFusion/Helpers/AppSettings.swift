//  AppSettings.swift

import Foundation

/// UserDefaults のキー一覧（既存ユーザーのデータを引き継ぐため、従来のキー名を維持している）
enum StorageKey {
    static let hasAgreedToTerms = "hasAgreedToTerms"
    static let isMusicEnabled = "isSoundEnabled"
    static let isSoundEffectsEnabled = "isSoundEffectsEnabled"
    static let isHapticsEnabled = "isHapticsEnabled"
    static let highScore = "HighScore"
    static let savedGame = "SavedGame"
}

enum AppSettings {
    /// 未設定の項目の初期値を登録する（アプリ起動時に呼ぶ）
    static func registerDefaults(_ defaults: UserDefaults = .standard) {
        defaults.register(defaults: [
            StorageKey.isMusicEnabled: true,
            StorageKey.isSoundEffectsEnabled: true,
            StorageKey.isHapticsEnabled: true,
        ])
    }

    static var appVersion: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "-"
        let build = info?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (\(build))"
    }
}
