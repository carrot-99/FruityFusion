// GameBoardView.swift

import SwiftUI

struct GameBoardView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var animate = false

    var body: some View {
        VStack {
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
            
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(0..<16, id: \.self) { index in
                    let row = index / 4
                    let col = index % 4
                    TileView(tile: viewModel.tiles[row][col])
                        .aspectRatio(1, contentMode: .fit)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: viewModel.tiles)
                }
            }
            
            if viewModel.isGameOver {
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding()
                    .scaleEffect(animate ? 1.2 : 1.0)
                    .opacity(animate ? 0.5 : 1.0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                            self.animate.toggle()
                        }
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView(viewModel: GameViewModel())
    }
}
