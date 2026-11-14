//  Haptics.swift

import UIKit

/// 設定に応じて触覚フィードバックを鳴らす
enum Haptics {
    private static var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: StorageKey.isHapticsEnabled)
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
