//  InterstitialAdManager.swift

import GoogleMobileAds
import UIKit

class InterstitialAdManager: NSObject, GADFullScreenContentDelegate {
    private var interstitialAd: GADInterstitialAd?
    @Published var isAdReady = false
    
    override init() {
        super.init()
        loadInterstitialAd()
    }
    
    private func loadInterstitialAd() {
        let adUnitID: String
        if let adUnitIDFromPlist = Bundle.main.infoDictionary?["AdInterstitialUnitID"] as? String {
            adUnitID = adUnitIDFromPlist
        } else {
            fatalError("AdUnitID not found in Info.plist")
        }
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            self?.isAdReady = true
        }
    }
    
    // 広告を表示するメソッド
    func showAd(from rootViewController: UIViewController) {
        if let ad = interstitialAd {
            ad.present(fromRootViewController: rootViewController)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    // MARK: - GADFullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // 広告が閉じられたら新しい広告をロードする
        loadInterstitialAd()
    }
}
