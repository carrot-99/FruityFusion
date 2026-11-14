//  TermsAndPrivacyAgreementView.swift

import SwiftUI

/// 初回起動時に表示する利用規約・プライバシーポリシーへの同意画面
struct TermsAndPrivacyAgreementView: View {
    let onAgree: () -> Void

    @State private var presentedDocument: Document?

    private enum Document: String, Identifiable {
        case terms, privacy
        var id: String { rawValue }
    }

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(FruitType.watermelon.imageName)
                    .resizable()
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(radius: 4)

                Text("FRUITY FUSION へようこそ")
                    .font(Theme.roundedFont(.title2, weight: .heavy))
                    .foregroundColor(Theme.neutral)
                    .multilineTextAlignment(.center)

                Text("本アプリでは、お客様の体験を向上させるために広告を表示します。ご利用の前に、利用規約とプライバシーポリシーをご確認ください。")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 0) {
                    documentRow("利用規約", systemImage: "doc.text", document: .terms)
                    Divider().padding(.leading, 48)
                    documentRow("プライバシーポリシー", systemImage: "hand.raised", document: .privacy)
                }
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.systemBackground))
                )

                Spacer()

                Button(action: onAgree) {
                    Text("同意してはじめる")
                }
                .buttonStyle(GameButtonStyle(color: Theme.primary))
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 16)
            .frame(maxWidth: 480)
        }
        .sheet(item: $presentedDocument) { document in
            NavigationView {
                Group {
                    switch document {
                    case .terms: TermsView()
                    case .privacy: PrivacyPolicyView()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("閉じる") { presentedDocument = nil }
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
    }

    private func documentRow(_ title: String, systemImage: String, document: Document) -> some View {
        Button {
            presentedDocument = document
        } label: {
            HStack {
                Image(systemName: systemImage)
                    .frame(width: 24)
                    .foregroundColor(Theme.primary)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
    }
}

struct TermsAndPrivacyAgreementView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndPrivacyAgreementView(onAgree: {})
    }
}
