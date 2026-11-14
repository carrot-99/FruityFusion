//  FruityFusionApp.swift

import SwiftUI
import GoogleMobileAds

@main
struct FruityFusionApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        AppSettings.registerDefaults()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        InterstitialAdManager.shared.preload()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                AudioManager.shared.resumeMusic()
            case .background:
                AudioManager.shared.pauseMusic()
            default:
                break
            }
        }
    }
}
