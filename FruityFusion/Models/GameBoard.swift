//  GameBoard.swift

import Foundation

enum MoveDirection: CaseIterable {
    case up, down, left, right
}

/// 1回の移動で起きたことのまとめ
struct MoveResult: Equatable {
    var moved = false
    var scoreGained = 0
    var mergedFruits: [FruitType] = []
    var clearedWatermelon = false
}

/// 盤面のロジック。音やスコア保存などの副作用は持たない純粋なモデル。
struct GameBoard: Equatable, Codable {
    static let size = 4

    struct Position: Hashable, Codable {
        let row: Int
        let col: Int
    }

    struct PlacedTile: Identifiable {
        let tile: FruitTile
        let position: Position
        var id: UUID { tile.id }
    }

    private(set) var tiles: [[FruitTile?]]

    init() {
        tiles = Array(repeating: Array(repeating: nil, count: Self.size), count: Self.size)
    }

    subscript(position: Position) -> FruitTile? {
        get { tiles[position.row][position.col] }
        set { tiles[position.row][position.col] = newValue }
    }

    // MARK: - 状態の参照

    var placedTiles: [PlacedTile] {
        allPositions.compactMap { position in
            self[position].map { PlacedTile(tile: $0, position: position) }
        }
    }

    var emptyPositions: [Position] {
        allPositions.filter { self[$0] == nil }
    }

    /// 盤面上で一番進化している果物
    var highestFruit: FruitType? {
        placedTiles.map(\.tile.fruit).max { $0.level < $1.level }
    }

    /// まだ動かせる手があるか
    var canMove: Bool {
        if !emptyPositions.isEmpty { return true }
        for row in 0..<Self.size {
            for col in 0..<Self.size {
                let fruit = tiles[row][col]?.fruit
                if col + 1 < Self.size, tiles[row][col + 1]?.fruit == fruit { return true }
                if row + 1 < Self.size, tiles[row + 1][col]?.fruit == fruit { return true }
            }
        }
        return false
    }

    // MARK: - 操作

    /// 指定方向にタイルを寄せて合体させる
    mutating func move(_ direction: MoveDirection) -> MoveResult {
        clearTurnFlags()
        let before = tiles
        var result = MoveResult()

        for line in lines(for: direction) {
            let collapsed = Self.collapse(line.compactMap { self[$0] }, into: &result)
            for (position, tile) in zip(line, collapsed) {
                self[position] = tile
            }
        }

        result.moved = tiles != before
        return result
    }

    /// 空いているマスにランダムなタイルを1枚追加する
    @discardableResult
    mutating func spawnRandomTile<G: RandomNumberGenerator>(using generator: inout G) -> Position? {
        guard let position = emptyPositions.randomElement(using: &generator) else { return nil }
        // さくらんぼ 80% / いちご 20%
        let fruit: FruitType = Double.random(in: 0..<1, using: &generator) < 0.8 ? .cherry : .strawberry
        self[position] = FruitTile(fruit: fruit, isNew: true)
        return position
    }

    @discardableResult
    mutating func spawnRandomTile() -> Position? {
        var generator = SystemRandomNumberGenerator()
        return spawnRandomTile(using: &generator)
    }

    // MARK: - 内部処理

    private var allPositions: [Position] {
        (0..<Self.size).flatMap { row in
            (0..<Self.size).map { col in Position(row: row, col: col) }
        }
    }

    private mutating func clearTurnFlags() {
        for position in allPositions {
            self[position]?.isNew = false
            self[position]?.isMerged = false
        }
    }

    /// 移動方向に対して「寄せる側」から並べたマスの列
    private func lines(for direction: MoveDirection) -> [[Position]] {
        let indices = Array(0..<Self.size)
        return indices.map { i in
            switch direction {
            case .left: return indices.map { Position(row: i, col: $0) }
            case .right: return indices.reversed().map { Position(row: i, col: $0) }
            case .up: return indices.map { Position(row: $0, col: i) }
            case .down: return indices.reversed().map { Position(row: $0, col: i) }
            }
        }
    }

    /// 1列分のタイルを先頭方向に寄せ、同じ果物を合体させる
    private static func collapse(_ line: [FruitTile], into result: inout MoveResult) -> [FruitTile?] {
        var output: [FruitTile?] = []
        var index = 0

        while index < line.count {
            let current = line[index]
            if index + 1 < line.count, line[index + 1].fruit == current.fruit {
                if let next = current.fruit.next {
                    output.append(FruitTile(fruit: next, isMerged: true))
                    result.scoreGained += next.score
                    result.mergedFruits.append(next)
                } else {
                    // スイカ同士はボーナスを得て両方消える
                    result.scoreGained += FruitType.watermelonClearBonus
                    result.clearedWatermelon = true
                }
                index += 2
            } else {
                output.append(current)
                index += 1
            }
        }

        output.append(contentsOf: Array(repeating: nil, count: size - output.count))
        return output
    }
}
