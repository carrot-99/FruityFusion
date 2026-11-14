//  InterstitialAdManager.swift

import GoogleMobileAds
import UIKit

/// インタースティシャル広告の読み込みと表示を管理する
final class InterstitialAdManager: NSObject, GADFullScreenContentDelegate {
    static let shared = InterstitialAdManager()

    private var interstitialAd: GADInterstitialAd?
    private var isLoading = false
    private let adUnitID = Bundle.main.infoDictionary?["AdInterstitialUnitID"] as? String

    var isReady: Bool { interstitialAd != nil }

    private override init() {
        super.init()
    }

    func preload() {
        guard let adUnitID, interstitialAd == nil, !isLoading else { return }
        isLoading = true
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
            guard let self else { return }
            self.isLoading = false
            if let error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            ad?.fullScreenContentDelegate = self
            self.interstitialAd = ad
        }
    }

    /// 準備ができていれば最前面の画面から広告を表示する
    func showIfReady() {
        guard let ad = interstitialAd, let controller = UIApplication.shared.topViewController else {
            preload()
            return
        }
        ad.present(fromRootViewController: controller)
    }

    // MARK: - GADFullScreenContentDelegate

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitialAd = nil
        preload()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        interstitialAd = nil
        preload()
    }
}

extension UIApplication {
    /// 現在最前面に表示されている ViewController
    var topViewController: UIViewController? {
        let keyWindow = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }

        var top = keyWindow?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}
