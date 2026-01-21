//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Albina Musugalieva
//
import UIKit

final class MovieQuizPresenter{
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepModel {
        let currentQuizQuestion = QuizStepModel(
            image: UIImage (data: model.imageData) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return currentQuizQuestion
    }
    
    private func handleAnswer(_ answer: Bool) {
        guard let currentQuestion else { return }
        
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
        
    }
    
    func noButtonClicked() {
        handleAnswer(false)
    }
    
    func yesButtonClicked() {
        handleAnswer(true)
    }
}
