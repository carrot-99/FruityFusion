//  GameView.swift

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isConfirmingRestart = false

    init(resume: Bool) {
        _viewModel = StateObject(wrappedValue: GameViewModel(resume: resume))
    }

    var body: some View {
        ZStack {
            ScreenBackground(imageName: "BackgroundImage")

            VStack(spacing: 16) {
                header
                GameBoardView(board: viewModel.board)
                FruitChainView(reached: viewModel.bestFruit)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .frame(maxWidth: 520)
            .contentShape(Rectangle())
            .gesture(swipeGesture)
            // VoiceOver 利用時にスワイプの代わりに使える操作
            .accessibilityAction(named: "上へ") { viewModel.move(.up) }
            .accessibilityAction(named: "下へ") { viewModel.move(.down) }
            .accessibilityAction(named: "左へ") { viewModel.move(.left) }
            .accessibilityAction(named: "右へ") { viewModel.move(.right) }

            if viewModel.isGameOver {
                GameOverView(
                    score: viewModel.score,
                    bestFruit: viewModel.bestFruit,
                    canUndo: viewModel.canUndo,
                    onRetry: retryAfterGameOver,
                    onUndo: { withAnimation { viewModel.undo() } },
                    onHome: { dismiss() }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.isGameOver)
        .navigationBarHidden(true)
        .onAppear {
            AudioManager.shared.playMusic(.game)
        }
        .confirmationDialog("ゲームをやり直しますか？", isPresented: $isConfirmingRestart, titleVisibility: .visible) {
            Button("やり直す", role: .destructive) {
                viewModel.startNewGame()
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("現在のスコアは失われます。")
        }
    }

    // MARK: - サブビュー

    private var header: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "house.fill")
                }
                .buttonStyle(IconButtonStyle())
                .accessibilityLabel("タイトルへ")

                Spacer()

                ScoreView(title: "スコア", value: viewModel.score.current, popup: viewModel.scorePopup)
                ScoreView(title: "ベスト", value: viewModel.score.best)
            }

            HStack(spacing: 10) {
                Spacer()
                Button {
                    withAnimation { viewModel.undo() }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                .buttonStyle(IconButtonStyle(color: Theme.secondary))
                .disabled(!viewModel.canUndo)
                .accessibilityLabel("1手もどす")

                Button {
                    isConfirmingRestart = true
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(IconButtonStyle(color: Theme.primary))
                .accessibilityLabel("やり直す")
            }
        }
    }

    // MARK: - 操作

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onEnded { value in
                let dx = value.translation.width
                let dy = value.translation.height
                if abs(dx) > abs(dy) {
                    viewModel.move(dx < 0 ? .left : .right)
                } else {
                    viewModel.move(dy < 0 ? .up : .down)
                }
            }
    }

    private func retryAfterGameOver() {
        InterstitialAdManager.shared.showIfReady()
        viewModel.startNewGame()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(resume: false)
    }
}
