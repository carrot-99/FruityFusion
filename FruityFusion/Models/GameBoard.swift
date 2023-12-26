//  GameBoard.swift

import Foundation

struct GameBoard {
    var tiles: [[FruitTile?]]
    var score: Int
    var scoreManager: ScoreManager?

    init(scoreManager: ScoreManager? = nil) {
        self.tiles = Array(repeating: Array(repeating: nil, count: 4), count: 4)
        self.score = 0
        self.scoreManager = scoreManager
    }

    mutating func swipeLeft() {
        var didChange = false
        for i in 0..<4 {
            let originalRow = tiles[i]
            let newRow = moveAndMergeTiles(originalRow)
            if newRow != originalRow { // 行が変化したかどうかをチェック
                didChange = true
                tiles[i] = newRow
            }
        }
        if didChange {
            // スコアの更新や新しいタイルの追加など
        }
    }
    
    mutating func swipeRight() {
        var didChange = false
        for i in 0..<4 {
            let originalRow = tiles[i].reversed() // 行を反転
            let newRow = moveAndMergeTiles(Array(originalRow)).reversed() // 左方向のロジックを適用して再度反転
            if Array(newRow) != tiles[i] {
                didChange = true
                tiles[i] = Array(newRow)
            }
        }
        if didChange {
            // スコアの更新や新しいタイルの追加など
        }
    }
    
    mutating func swipeUp() {
        var didChange = false
        for col in 0..<4 {
            var column = [FruitTile?]() // 空の列を作成
            for row in 0..<4 {
                column.append(tiles[row][col]) // 現在の列を取得
            }
            let newColumn = moveAndMergeTiles(column)
            if newColumn != column {
                didChange = true
                for row in 0..<4 {
                    tiles[row][col] = newColumn[row] // 結果を元の位置に戻す
                }
            }
        }
        if didChange {
            // スコアの更新や新しいタイルの追加など
        }
    }
    
    mutating func swipeDown() {
        var didChange = false
        for col in 0..<4 {
            var column = [FruitTile?]() // 空の列を作成
            for row in 0..<4 {
                column.append(tiles[row][col]) // 現在の列を取得
            }
            let newColumn = moveAndMergeTiles(Array(column.reversed())).reversed() // 配列に変換してからロジックを適用し、再度反転

            // 新しい列が元の列と異なるかチェック
            if Array(newColumn) != column { // Array()を使用してReversedCollectionを配列に変換
                didChange = true
                for (row, tile) in newColumn.enumerated() {
                    tiles[row][col] = tile // 新しいタイルを正しい位置に配置
                }
            }
        }
        if didChange {
            // スコアの更新や新しいタイルの追加など
        }
    }
    
    private mutating func moveAndMergeTiles(_ originalRow: [FruitTile?]) -> [FruitTile?] {
        var row = originalRow.compactMap { $0 } // nilでないタイルを取得
        var newRow: [FruitTile?] = [nil, nil, nil, nil]
        var targetIndex = 0 // タイルを配置する次の位置

        while !row.isEmpty {
            if row.count > 1 && row[0].fruit == row[1].fruit {
                if row[0].fruit == .watermelon {
                    AudioManager.shared.playWatermelonMergeSound()
                    scoreManager?.addScore(for: FruitTile(fruit: .superWatermelon, score: 4096))
                    newRow[targetIndex] = nil
                    targetIndex += 1
                    newRow[targetIndex] = nil
                } else {
                    AudioManager.shared.playMergeSound() 
                    let mergedTile = FruitTile(fruit: row[0].fruit.next())
                    newRow[targetIndex] = mergedTile
                    scoreManager?.addScore(for: mergedTile)
                }
                row.removeFirst(2)
            } else {
                // そうでなければ、タイルを新しい行の次の位置に移動
                newRow[targetIndex] = row.removeFirst()
            }
            targetIndex += 1
        }

        return newRow
    }


    // ゲームオーバー条件をチェックする関数
    func isGameOver() -> Bool {
        for row in 0..<4 {
            for col in 0..<4 {
                if tiles[row][col] == nil {
                    // 空きタイルがあれば、まだゲームオーバーではない
                    return false
                }
                // 隣接するタイルとの合体可能性をチェック
                if col < 3, let current = tiles[row][col], let right = tiles[row][col + 1], current.fruit == right.fruit {
                    return false
                }
                if row < 3, let current = tiles[row][col], let down = tiles[row + 1][col], current.fruit == down.fruit {
                    return false
                }
            }
        }
        // どのタイルも動かせない場合はゲームオーバー
        return true
    }
}
