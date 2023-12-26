//  GameView.swift

import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()
    @State private var interstitialAdManager = InterstitialAdManager()
    
    init() {
        AudioManager.shared.stopBackgroundMusic()  // 背景音楽を停止
        AudioManager.shared.playGameMusic()        // ゲーム用の音楽を再生
    }

    var body: some View {
        VStack {
            HStack {
                ScoreView(scoreManager: viewModel.scoreManager)
                    .padding()
                
                Text("ハイスコア: \(viewModel.scoreManager.highScore)")
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
            }
            
            GameBoardView(viewModel: viewModel)
                .padding()

            .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onEnded({ value in
                    // スワイプ方向を判定し、対応するアクションを実行
                    if abs(value.translation.width) > abs(value.translation.height) {
                        // 横方向のスワイプ
                        value.translation.width < 0 ? viewModel.swipeLeft() : viewModel.swipeRight()
                    } else {
                        // 縦方向のスワイプ
                        value.translation.height < 0 ? viewModel.swipeUp() : viewModel.swipeDown()
                    }
                }))
            
            Button(action: {
                if viewModel.isGameOver {
                    if let controller = topMostViewController() {
                        interstitialAdManager.showAd(from: controller)
                    } else {
                        print("広告はまだ準備ができていません。しばらくしてからもう一度お試しください。")
                    }
                }
                viewModel.startGame()
                viewModel.isGameOver = false
            }) {
                Text("ゲームをリセット")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            // GameViewが表示されるときに呼ばれる
            AudioManager.shared.stopBackgroundMusic()  // 背景音楽を停止
            AudioManager.shared.playGameMusic()        // ゲーム用の音楽を再生
        }
        .onDisappear {
            // GameViewが非表示になるときに呼ばれる
            AudioManager.shared.stopGameMusic()  // ゲーム用の音楽を停止
            AudioManager.shared.playBackgroundMusic()  // 背景音楽を再生
        }
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
                return nil
        }
        
        var topController: UIViewController? = keyWindow.rootViewController
        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }
        
        return topController
    }

}
