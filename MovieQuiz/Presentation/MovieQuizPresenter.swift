//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Albina Musugalieva
//
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate{
    private var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var statisticService: StatisticServiceProtocol  = StatisticService()
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.loadData()
        viewController.showLoadingIndicator()
    }
    
    
    // MARK: - Private Functions
    
    private func loadFirstQuestion(){
        questionFactory.loadData()
    }
    
    
    private func handleAnswer(_ answer: Bool) {
        guard let currentQuestion else { return }
        
        self.proceedWithAnswer(isCorrect: answer == currentQuestion.correctAnswer)
        
    }
    
    
    
    private func setupQuestionFactory(){
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
    }
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    
    // MARK: - Functions
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        
        questionFactory.requestNextQuestion()
    }
    
    
    
    func noButtonClicked() {
        handleAnswer(false)
    }
    
    func yesButtonClicked() {
        handleAnswer(true)
    }
    
    func convert(model: QuizQuestion) -> QuizStepModel {
        let currentQuizQuestion = QuizStepModel(
            image: UIImage (data: model.imageData) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questionsAmount)")
        return currentQuizQuestion
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(gameResult: GameResult(correct: correctAnswers, total: self.questionsAmount, date: Date()))
            let text = "Ваш результат: \(correctAnswers)/10\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            let viewModel = QuizResultsModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
        
    }
    func restartGame(){
        self.resetQuestionIndex()
        self.correctAnswers = 0
        questionFactory.requestNextQuestion()
        
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.proceedToNextQuestionOrResults()
            // setButtonsEnabled(true)
            
        }
        
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
}
