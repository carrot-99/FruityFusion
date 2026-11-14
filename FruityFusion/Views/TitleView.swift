// TitleView.swift

import SwiftUI

struct TitleView: View {
    @State private var isSettingsPresented = false
    @State private var hasSavedGame = false
    @State private var highScore = 0
    @State private var isLogoAnimating = false

    var body: some View {
        NavigationView {
            ZStack {
                ScreenBackground(imageName: "TitleImage")

                VStack(spacing: 14) {
                    Spacer()

                    logo

                    if highScore > 0 {
                        Label("ベスト \(highScore)", systemImage: "crown.fill")
                            .font(Theme.roundedFont(.headline))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Theme.secondary))
                            .shadow(radius: 3)
                    }

                    Spacer()

                    if hasSavedGame {
                        NavigationLink(destination: GameView(resume: true)) {
                            Label("つづきから", systemImage: "play.fill")
                        }
                        .buttonStyle(GameButtonStyle(color: Theme.primary))
                    }

                    NavigationLink(destination: GameView(resume: false)) {
                        Label("あたらしく始める", systemImage: hasSavedGame ? "plus" : "play.fill")
                    }
                    .buttonStyle(GameButtonStyle(color: hasSavedGame ? Theme.secondary : Theme.primary))

                    Button {
                        isSettingsPresented = true
                    } label: {
                        Label("設定", systemImage: "gearshape.fill")
                    }
                    .buttonStyle(GameButtonStyle(color: Theme.neutral))

                    Spacer()
                }
                .padding(.horizontal, 32)
                .frame(maxWidth: 460)
            }
            .navigationBarHidden(true)
            .onAppear(perform: refresh)
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $isSettingsPresented, onDismiss: refresh) {
            SettingsView()
        }
    }

    private var logo: some View {
        Text("FRUITY\nFUSION")
            .font(.system(size: 52, weight: .heavy, design: .rounded))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 2, y: 2)
            .padding(.vertical, 16)
            .padding(.horizontal, 28)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.mint)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white, lineWidth: 5)
            )
            .rotationEffect(.degrees(isLogoAnimating ? 2 : -2))
            .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: isLogoAnimating)
            .onAppear { isLogoAnimating = true }
            .accessibilityLabel("Fruity Fusion")
            .accessibilityAddTraits(.isHeader)
    }

    private func refresh() {
        let storage = GameStorage.standard
        hasSavedGame = storage.hasSavedGame
        highScore = storage.highScore
        AudioManager.shared.playMusic(.title)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
