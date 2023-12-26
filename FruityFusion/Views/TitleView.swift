//  TitleView.swift

import SwiftUI

struct TitleView: View {
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
                Text("2048スタイルのパズルゲームで、果物を合体させてスコアを稼ごう！")
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
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// プレビュー用
struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TitleView()
        }
    }
}
