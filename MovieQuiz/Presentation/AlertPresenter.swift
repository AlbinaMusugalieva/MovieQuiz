//
// AlertPresenter.swift
//  MovieQuiz
//
//  Created by Albina Musugalieva
//
import UIKit

final class AlertPresenter {
    // MARK: - Public Methods
    func show(in vc: UIViewController, model: AlertModel) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
