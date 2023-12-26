//  FruitTile.swift

import Foundation

// 果物の種類を表す列挙型
enum FruitType: String, CaseIterable {
    case cherry = "Cherry"
    case strawberry = "Strawberry"
    case grape = "Grape"
    case dekopon = "Dekopon"
    case persimmon = "Persimmon"
    case apple = "Apple"
    case pear = "Pear"
    case pineapple = "Pineapple"
    case peach = "Peach"
    case melon = "Melon"
    case watermelon = "Watermelon"
    case superWatermelon = "SuperWatermelon"
    
    
    func next() -> FruitType {
        if self == .watermelon {
            return .superWatermelon
        }
        if let currentIndex = FruitType.allCases.firstIndex(of: self),
           currentIndex + 1 < FruitType.allCases.count {
            return FruitType.allCases[currentIndex + 1]
        }
        return self // 最後の進化段階の場合はそのまま
    }
}

// ゲームのタイルを表す構造体
struct FruitTile: Equatable {
    var fruit: FruitType
    var score: Int

    // 果物に応じたタイルの初期化
    init(fruit: FruitType, score: Int? = nil) {
        self.fruit = fruit
        self.score = score ?? 0
    }

    // タイルを次の進化段階に更新する関数
    mutating func evolve() {
        if let currentIndex = FruitType.allCases.firstIndex(of: self.fruit),
           currentIndex + 1 < FruitType.allCases.count {
            let nextFruit = FruitType.allCases[currentIndex + 1]
            self.fruit = nextFruit
        }
    }
}
