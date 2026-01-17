//
// AlertModel.swift
//  MovieQuiz
//
//  Created by Albina Musugalieva
//
import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
} 
