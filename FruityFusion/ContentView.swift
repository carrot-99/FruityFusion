//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
    @State private var isShowingTerms = true
    @State private var hasAgreedToTerms = UserDefaults.standard.bool(forKey: "hasAgreedToTerms")

    var body: some View {
        ZStack(alignment: .bottom) {
            if hasAgreedToTerms {
                TitleView()
                
                AdMobBannerView()
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .background(Color.gray.opacity(0.1))
            } else {
                TermsAndPrivacyAgreementView(isShowingTerms: $isShowingTerms, hasAgreedToTerms: $hasAgreedToTerms)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
