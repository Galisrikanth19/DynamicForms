//
//  ResponseModel.swift
//  Created by GaliSrikanth on 27/02/25.

import SwiftUI

class SectionModel: Identifiable {
    let id = UUID()
    @Published var questions: [QuestionModel]
    
    init(questions: [QuestionModel]) {
        self.questions = questions
    }
}

class QuestionModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var answer: [String]
    let componentType: String
    let question: String
    @Published var errMsg: String
    
    init(answer: [String],
         componentType: String,
         question: String,
         errMsg: String) {
        self.answer = answer
        self.componentType = componentType
        self.question = question
        self.errMsg = errMsg
    }
}
