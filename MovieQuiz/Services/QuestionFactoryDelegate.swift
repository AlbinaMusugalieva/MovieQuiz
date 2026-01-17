//
// QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Albina Musugalieva
//
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)   
}
