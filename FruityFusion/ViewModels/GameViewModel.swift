//  GameViewModel.swift

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var gameBoard = GameBoard()
    @Published var scoreManager = ScoreManager()
    @Published var isGameOver = false

    init() {
        gameBoard = GameBoard(scoreManager: scoreManager)
        startGame()
    }

    func startGame() {
        gameBoard = GameBoard(scoreManager: scoreManager)
        scoreManager.resetScore()
        
        addRandomTile()
        addRandomTile()
    }

    func swipeLeft() {
        gameBoard.swipeLeft()
        updateGame()
    }

    func swipeRight() {
        gameBoard.swipeRight()
        updateGame()
    }

    func swipeUp() {
        gameBoard.swipeUp()
        updateGame()
    }

    func swipeDown() {
        gameBoard.swipeDown()
        updateGame()
    }

    private func updateGame() {
        addRandomTile()
        if gameBoard.isGameOver() {
            isGameOver = true
            AudioManager.shared.playGameOverSound()
        }
    }

    var tiles: [[FruitTile?]] {
        gameBoard.tiles
    }

    var score: Int {
        scoreManager.currentScore
    }

    // 空いている位置にランダムなタイルを追加する
    private func addRandomTile() {
        var emptyPositions = [(Int, Int)]() // 空の位置を保持するための配列

        // 空の位置を探します。
        for (rowIndex, row) in gameBoard.tiles.enumerated() {
            for (colIndex, tile) in row.enumerated() {
                if tile == nil {
                    emptyPositions.append((rowIndex, colIndex))
                }
            }
        }

        // 空の位置があれば、ランダムな位置に新しいタイルを追加します。
        if let randomPosition = emptyPositions.randomElement() {
            let (row, col) = randomPosition
            let newTile = FruitTile(fruit: getRandomFruit())
            gameBoard.tiles[row][col] = newTile
        }
    }
    
    private func getRandomFruit() -> FruitType {
        let fruits = [FruitType.cherry, FruitType.strawberry]
        return fruits.randomElement() ?? .cherry
    }
}
