//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @AppStorage(StorageKey.hasAgreedToTerms) private var hasAgreedToTerms = false

    var body: some View {
        if hasAgreedToTerms {
            TitleView()
                // バナーがゲーム画面やボタンに重ならないよう、セーフエリアとして下部に確保する
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    AdMobBannerView()
                        .background(.bar)
                }
        } else {
            TermsAndPrivacyAgreementView {
                hasAgreedToTerms = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
