//  TitleView.swift

import SwiftUI

struct TitleView: View {
    @State private var isSettingsPresented = false
    @State private var isSoundEnabled: Bool = UserDefaults.standard.bool(forKey: "isSoundEnabled")
    
    var body: some View {
        NavigationView {
            VStack {
                // タイトルテキストを強調
                Text("フルーティフュージョン")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(.orange)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    .padding()
                
                // サブタイトルテキスト
                Text("果物を合体させてスコアを稼ごう！")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
                
                // ゲーム開始ボタン
                NavigationLink(destination: GameView()) {
                    Text("ゲームを始める")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                Button(action: {
                    isSettingsPresented = true
                }) {
                    Text("設定") // システムアイコンを使用
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            AudioManager.shared.stopGameMusic()        // ゲーム音楽を停止
            AudioManager.shared.playBackgroundMusic()  // 背景音楽を再生
        }
        .sheet(isPresented: $isSettingsPresented) {
            // 設定画面を表示
            SettingsView(isSoundEnabled: $isSoundEnabled)
        }
    }
}
