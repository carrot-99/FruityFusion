//  AdMobBannerView.swift

import SwiftUI
import GoogleMobileAds

/// 画面幅に合わせたアダプティブバナー。広告IDが無い場合は何も表示しない。
struct AdMobBannerView: View {
    private let adUnitID = Bundle.main.infoDictionary?["AdBannerUnitID"] as? String

    var body: some View {
        if let adUnitID {
            let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
            BannerRepresentable(adUnitID: adUnitID, adSize: adSize)
                .frame(width: adSize.size.width, height: adSize.size.height)
                .frame(maxWidth: .infinity)
        }
    }
}

private struct BannerRepresentable: UIViewRepresentable {
    let adUnitID: String
    let adSize: GADAdSize

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: adSize)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.topViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ banner: GADBannerView, context: Context) {
        if banner.rootViewController == nil {
            banner.rootViewController = UIApplication.shared.topViewController
        }
    }
}
