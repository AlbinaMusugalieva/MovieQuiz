import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ previousResult: GameResult) -> Bool {
        correct > previousResult.correct
    }
}
