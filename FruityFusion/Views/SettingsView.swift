// SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @Binding var isSoundEnabled: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $isSoundEnabled) {
                        Text("Sound")
                    }
                    .onChange(of: isSoundEnabled) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "isSoundEnabled")
                        AudioManager.shared.setSoundEnabled(newValue)
                    }
                }

                Section(header: Text("Information")) {
                    NavigationLink(destination: TermsView()) {
                        Text("利用規約")
                    }

                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("プライバシーポリシー")
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
