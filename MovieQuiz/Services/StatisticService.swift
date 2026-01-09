import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
    
    var gamesCount: Int{
        get{
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set{
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult{
        get{
           GameResult(correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                      total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                      date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date())
        }
        
        set{
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
        
    }
    
    var totalAccuracy: Double{
       var totalCorrectAnswers: Int = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
       var totalQuestionsAsked: Int = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        
        if totalQuestionsAsked != 0 {
            return Double(totalCorrectAnswers)/Double(totalQuestionsAsked)*100
        }
        else {
            return 0
        }
        
    }
    
    func store(gameResult: GameResult) {
        var totalCorrectAnswers: Int = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        var totalQuestionsAsked: Int = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        
        storage.set(gamesCount+1,forKey: Keys.gamesCount.rawValue)
        
        if gameResult.isBetterThan(bestGame){
            storage.set(gameResult.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(gameResult.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(gameResult.date, forKey: Keys.bestGameDate.rawValue)
        }
        
        storage.set(totalCorrectAnswers+gameResult.correct, forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(totalQuestionsAsked+gameResult.total, forKey: Keys.totalQuestionsAsked.rawValue)
        
    }
    
     
}
