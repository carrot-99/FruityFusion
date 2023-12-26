//  ScoreView.swift

import SwiftUI

// スコアを表示するビュー
struct ScoreView: View {
    // スコアマネージャーを監視対象として宣言
    @ObservedObject var scoreManager: ScoreManager

    var body: some View {
        // スコア表示用のコンテナ
        HStack {
            // スコアラベル
            Text("スコア:")
                .font(.title2)
                .fontWeight(.bold)
            
            // 現在のスコアを表示
            Text("\(scoreManager.currentScore)")
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color.orange)
        .cornerRadius(10)
        .foregroundColor(.white)
        .shadow(radius: 5)
    }
}

// プレビュー用のコード
struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(scoreManager: ScoreManager())
    }
}
