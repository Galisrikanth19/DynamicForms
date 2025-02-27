//
//  FormViewModel.swift
//  Created by GaliSrikanth on 27/02/25.

import SwiftUI

class FormViewModel: ObservableObject {
    @Published var message: String = "Loading..."
    @Published var sections: [SectionModel] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.message = "GeneralForms"

            let quesM = QuestionModel(answer: ["Srikanth"], componentType: "text", question: "FirstName", errMsg: "")
            let quesM1 = QuestionModel(answer: ["Gali"], componentType: "text", question: "LastName", errMsg: "")
            let sectionM = SectionModel(questions: [quesM, quesM1])

            let quesM2 = QuestionModel(answer: ["Doc"], componentType: "text", question: "Profession1", errMsg: "")
            let quesM3 = QuestionModel(answer: ["Engi"], componentType: "text", question: "Profession2", errMsg: "")
            let sectionM1 = SectionModel(questions: [quesM2, quesM3])

            self.sections = [sectionM, sectionM1]
        }
    }
    
    func submitForm() {
        for sectionIndex in sections.indices {
            for questionIndex in sections[sectionIndex].questions.indices {
                let firstAnswer = (sections[sectionIndex].questions[questionIndex].answer.first ?? "")
                if firstAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    sections[sectionIndex].questions[questionIndex].errMsg = "Invalid"
                } else {
                    sections[sectionIndex].questions[questionIndex].errMsg = ""
                }
            }
        }
        
        updateForm()
        printData()
    }
    
    // Ensure UI updates
    func updateForm() {
        objectWillChange.send()
    }
    
    // Prints all data
    func printData() {
        dump(sections)
    }
}
