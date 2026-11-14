//  GameViewModel.swift

import Foundation

/// スコア加算時の「+N」表示用
struct ScorePopup: Identifiable, Equatable {
    let id = UUID()
    let points: Int
}

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var board = GameBoard()
    @Published private(set) var score: ScoreManager
    @Published private(set) var isGameOver = false
    @Published private(set) var scorePopup: ScorePopup?
    /// このゲームで到達した最高の果物
    @Published private(set) var bestFruit: FruitType = .cherry

    private var undoSnapshot: Snapshot?
    private let storage: GameStorage

    private struct Snapshot {
        let board: GameBoard
        let score: ScoreManager
        let bestFruit: FruitType
    }

    var canUndo: Bool { undoSnapshot != nil }

    init(resume: Bool = false, storage: GameStorage = .standard) {
        self.storage = storage
        self.score = ScoreManager(best: storage.highScore)

        if resume, let saved = storage.loadGame() {
            board = saved.board
            score = ScoreManager(current: saved.score, best: storage.highScore)
            bestFruit = saved.board.highestFruit ?? .cherry
            isGameOver = !board.canMove
        } else {
            startNewGame()
        }
    }

    // MARK: - ユーザー操作

    func move(_ direction: MoveDirection) {
        guard !isGameOver else { return }

        var newBoard = board
        let result = newBoard.move(direction)
        guard result.moved else {
            Haptics.impact(.rigid)
            return
        }

        undoSnapshot = Snapshot(board: board, score: score, bestFruit: bestFruit)
        newBoard.spawnRandomTile()
        board = newBoard

        apply(result)
        isGameOver = !board.canMove
        persist()

        if isGameOver {
            AudioManager.shared.play(.gameOver)
            Haptics.notify(score.isNewRecord ? .success : .error)
        }
    }

    /// 1手前の状態に戻す（連続では使えない）
    func undo() {
        guard let snapshot = undoSnapshot else { return }
        board = snapshot.board
        score = ScoreManager(current: snapshot.score.current, best: score.best, isNewRecord: score.isNewRecord)
        bestFruit = snapshot.bestFruit
        isGameOver = false
        undoSnapshot = nil
        scorePopup = nil
        persist()
        Haptics.impact(.light)
    }

    func startNewGame() {
        var newBoard = GameBoard()
        newBoard.spawnRandomTile()
        newBoard.spawnRandomTile()
        board = newBoard
        score.reset()
        bestFruit = board.highestFruit ?? .cherry
        isGameOver = false
        undoSnapshot = nil
        scorePopup = nil
        persist()
    }

    // MARK: - 内部処理

    private func apply(_ result: MoveResult) {
        if result.scoreGained > 0 {
            score.add(result.scoreGained)
            storage.highScore = score.best
            scorePopup = ScorePopup(points: result.scoreGained)
        }

        if let highest = result.mergedFruits.max(by: { $0.level < $1.level }), highest.level > bestFruit.level {
            bestFruit = highest
        }

        if result.clearedWatermelon {
            AudioManager.shared.play(.watermelonMerge)
            Haptics.notify(.success)
        } else if !result.mergedFruits.isEmpty {
            AudioManager.shared.play(.merge)
            Haptics.impact(.medium)
        } else {
            Haptics.impact(.light)
        }
    }

    /// 進行中のゲームを保存する。終了したゲームは「つづきから」の対象にしない。
    private func persist() {
        if isGameOver {
            storage.clearSavedGame()
        } else {
            storage.saveGame(SavedGame(board: board, score: score.current))
        }
    }
}
