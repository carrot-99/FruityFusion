// TitleView.swift

import SwiftUI

struct TitleView: View {
    @State private var isSettingsPresented = false
    @State private var isSoundEnabled: Bool = UserDefaults.standard.bool(forKey: "isSoundEnabled")

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("TitleImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()

                    VStack {
                        Spacer() // これにより、要素が縦方向の中央に配置されます

                        Text("フルーティ\nフュージョン")
                            .font(.system(size: 48, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding()
                            .background(Color.mint)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 5)
                            )
                            .padding(.horizontal)

                        NavigationLink(destination: GameView()) {
                            Text("ゲームを始める")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity) // これによりボタンが親ビューの幅いっぱいに広がります
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)

                        Button(action: {
                            isSettingsPresented = true
                        }) {
                            Text("設定")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity) // これも同様に幅いっぱいに広がります
                                .background(Color.brown)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)

                        Spacer() // これも同様
                    }
                    .frame(width: geometry.size.width) // VStackの幅を設定
                }
            }
            .edgesIgnoringSafeArea(.all) // これにより背景画像が全画面になります
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            AudioManager.shared.stopGameMusic()
            AudioManager.shared.playBackgroundMusic()
        }
        .sheet(isPresented: $isSettingsPresented) {
            // 設定画面を表示
            SettingsView(isSoundEnabled: $isSoundEnabled)
        }
    }
}
