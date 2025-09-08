//
//  DiceEngine.swift
//  Trench Assistant
//

import Foundation

struct DiceEngine {
    static func allRolls(n: Int) -> [[Int]] {
        if n == 0 { return [[]] }
        let smaller = allRolls(n: n - 1)
        var result: [[Int]] = []
        for combo in smaller {
            for face in 1...6 {
                result.append(combo + [face])
            }
        }
        return result
    }

    static func bestOf(_ rolls: [Int], keep: Int) -> Int {
        return rolls.sorted(by: >).prefix(keep).reduce(0, +)
    }

    static func calculateProbabilities(n: Int, keep: Int, armour: Int = 0, bonus: Int = 0) -> [String: Double] {
        let rolls = allRolls(n: n)
        var counts: [String: Int] = [
            "No Effect": 0,
            "Minor Hit": 0,
            "Down": 0,
            "Out of Action": 0
        ]
        
        for roll in rolls {
            var total = bestOf(roll, keep: keep)
            
            total -= armour  // Armour value (-1, -2, -3).
            total += bonus   // Bonuses: (+1 -> +6).
                       
            switch total {
            case Int.min...1: counts["No Effect"]! += 1
            case 2...6: counts["Minor Hit"]! += 1
            case 7...8: counts["Down"]! += 1
            default: counts["Out of Action"]! += 1
            }
        }
        
        let totalRolls = Double(rolls.count)
        return counts.mapValues { Double($0) / totalRolls * 100.0 }
    }
}
