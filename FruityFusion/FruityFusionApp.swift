//  FruityFusionApp.swift

import SwiftUI

@main
struct FruityFusionApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                // アプリがアクティブになったときの処理
                if let lastScene = AudioManager.shared.lastActiveScene {
                    // 最後にアクティブだったシーンに基づいて適切な音楽を再生
                    switch lastScene {
                    case .title:
                        AudioManager.shared.playBackgroundMusic()
                    case .game:
                        AudioManager.shared.playGameMusic()
                    }
                }
            case .inactive:
                // アプリが非アクティブになったときの処理
                break
            case .background:
                // アプリがバックグラウンドに移行したときの処理
                AudioManager.shared.stopBackgroundMusic()
                AudioManager.shared.stopGameMusic()
            @unknown default:
                break
            }
        }
    }
}
