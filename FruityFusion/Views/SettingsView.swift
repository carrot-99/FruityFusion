// SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(StorageKey.isMusicEnabled) private var isMusicEnabled = true
    @AppStorage(StorageKey.isSoundEffectsEnabled) private var isSoundEffectsEnabled = true
    @AppStorage(StorageKey.isHapticsEnabled) private var isHapticsEnabled = true
    @State private var isConfirmingReset = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("サウンド")) {
                    Toggle(isOn: $isMusicEnabled) {
                        Label("BGM", systemImage: "music.note")
                    }
                    Toggle(isOn: $isSoundEffectsEnabled) {
                        Label("効果音", systemImage: "speaker.wave.2.fill")
                    }
                    Toggle(isOn: $isHapticsEnabled) {
                        Label("振動", systemImage: "iphone.radiowaves.left.and.right")
                    }
                }

                Section(header: Text("データ")) {
                    Button(role: .destructive) {
                        isConfirmingReset = true
                    } label: {
                        Label("ハイスコアをリセット", systemImage: "trash")
                    }
                }

                Section(header: Text("情報")) {
                    NavigationLink(destination: TermsView()) {
                        Label("利用規約", systemImage: "doc.text")
                    }
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("プライバシーポリシー", systemImage: "hand.raised")
                    }
                    HStack {
                        Label("バージョン", systemImage: "info.circle")
                        Spacer()
                        Text(AppSettings.appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") { dismiss() }
                }
            }
            .onChange(of: isMusicEnabled) { isEnabled in
                AudioManager.shared.setMusicEnabled(isEnabled)
            }
            .alert("ハイスコアをリセットしますか？", isPresented: $isConfirmingReset) {
                Button("リセット", role: .destructive) {
                    GameStorage.standard.highScore = 0
                    Haptics.notify(.warning)
                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text("この操作は取り消せません。")
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
