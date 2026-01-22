//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Albina Musugalieva
//

import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Functions
    
    
    func show(quiz step: QuizStepModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
        setButtonsEnabled(true)
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    
    
    func show(quiz result: QuizResultsModel) {
     
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            
            presenter.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
        
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
            
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Private Functions
    
    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        setButtonsEnabled(false)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        setButtonsEnabled(false)
    }
}
