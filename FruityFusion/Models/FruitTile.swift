//  FruitTile.swift

import Foundation

/// 果物の種類。宣言順がそのまま進化の順番になる。
enum FruitType: String, CaseIterable, Codable {
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

    /// スイカ同士を合体させたときのボーナス得点（両方とも盤面から消える）
    static let watermelonClearBonus = 4096

    /// 進化段階（さくらんぼ = 1）
    var level: Int {
        (Self.allCases.firstIndex(of: self) ?? 0) + 1
    }

    /// 次の進化先。スイカは最終段階なので nil。
    var next: FruitType? {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self), index + 1 < all.count else { return nil }
        return all[index + 1]
    }

    /// この果物が合体で生まれたときに加算される得点（2, 4, 8, ... 2048）
    var score: Int {
        1 << level
    }

    var imageName: String {
        "\(rawValue)TileImage"
    }

    var displayName: String {
        switch self {
        case .cherry: return "さくらんぼ"
        case .strawberry: return "いちご"
        case .grape: return "ぶどう"
        case .dekopon: return "デコポン"
        case .persimmon: return "かき"
        case .apple: return "りんご"
        case .pear: return "なし"
        case .pineapple: return "パイナップル"
        case .peach: return "もも"
        case .melon: return "メロン"
        case .watermelon: return "スイカ"
        }
    }
}

/// 盤面上の1枚のタイル
struct FruitTile: Identifiable, Equatable, Codable {
    let id: UUID
    var fruit: FruitType
    /// 直前のターンで新しく出現したタイルか
    var isNew: Bool
    /// 直前のターンで合体して生まれたタイルか
    var isMerged: Bool

    init(id: UUID = UUID(), fruit: FruitType, isNew: Bool = false, isMerged: Bool = false) {
        self.id = id
        self.fruit = fruit
        self.isNew = isNew
        self.isMerged = isMerged
    }
}
