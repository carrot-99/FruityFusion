// GameBoardView.swift

import SwiftUI

/// 盤面。タイルを id で追跡して配置するので、移動がスライドアニメーションになる。
struct GameBoardView: View {
    let board: GameBoard

    private let spacing: CGFloat = 8
    private var size: Int { GameBoard.size }

    var body: some View {
        GeometryReader { geometry in
            let side = geometry.size.width
            let cell = (side - spacing * CGFloat(size + 1)) / CGFloat(size)

            ZStack(alignment: .topLeading) {
                // 空きマス
                ForEach(0..<size * size, id: \.self) { index in
                    RoundedRectangle(cornerRadius: cell * 0.16, style: .continuous)
                        .fill(Theme.emptyCell)
                        .frame(width: cell, height: cell)
                        .position(center(row: index / size, col: index % size, cell: cell))
                }

                // タイル
                ForEach(board.placedTiles) { placed in
                    TileView(tile: placed.tile)
                        .frame(width: cell, height: cell)
                        .position(center(row: placed.position.row, col: placed.position.col, cell: cell))
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.2).combined(with: .opacity),
                                removal: .opacity
                            )
                        )
                        .zIndex(placed.tile.isMerged ? 1 : 0)
                }
            }
            .frame(width: side, height: side)
            .animation(.easeInOut(duration: 0.13), value: board)
        }
        .aspectRatio(1, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Theme.boardBackground)
                .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("ゲーム盤")
    }

    private func center(row: Int, col: Int, cell: CGFloat) -> CGPoint {
        CGPoint(
            x: spacing + CGFloat(col) * (cell + spacing) + cell / 2,
            y: spacing + CGFloat(row) * (cell + spacing) + cell / 2
        )
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        var board = GameBoard()
        board.spawnRandomTile()
        board.spawnRandomTile()
        return GameBoardView(board: board).padding()
    }
}
