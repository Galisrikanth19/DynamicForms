//
//  FormView.swift
//  Created by GaliSrikanth on 27/02/25.

import SwiftUI

struct FormView: View {
    @StateObject var viewModel = FormViewModel()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        sectionsView()

                        Spacer()
                        
                        Button {
                            viewModel.submitForm()
                        } label: {
                            Text("SubmitForm")
                        }

                        Button {
                            viewModel.printData()
                        } label: {
                            Text("PrintData")
                        }
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height) // Ensures full height
                }
                .navigationTitle(viewModel.message)
            }
        }
    }


    @ViewBuilder
    private func sectionsView() -> some View {
        ForEach(viewModel.sections) { section in
            sectionView(for: section)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }

    @ViewBuilder
    private func sectionView(for section: SectionModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Section \(section.id.uuidString.prefix(5))")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(section.questions) { question in
                textField(for: question, in: section)
            }
        }
        .padding()
    }

    private func textField(for question: QuestionModel, in section: SectionModel) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(question.question)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("Enter \(question.question)", text: binding(for: question, in: section), onCommit: {
                if let sectionIndex = viewModel.sections.firstIndex(where: { $0.id == section.id }),
                   let questionIndex = viewModel.sections[sectionIndex].questions.firstIndex(where: { $0.id == question.id }) {
                    let answer: String = (viewModel.sections[sectionIndex].questions[questionIndex].answer.first ?? "")
                    // Check if the text is empty or not
                    if answer.isEmpty {
                        viewModel.sections[sectionIndex].questions[questionIndex].errMsg = "Invalid ques"
                    } else {
                        viewModel.sections[sectionIndex].questions[questionIndex].errMsg = ""
                    }
                    
                    viewModel.updateForm()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(5)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 1)
            
            if !question.errMsg.isEmpty {
                Text(question.errMsg)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 2)
            }
        }
    }
    
    private func binding(for question: QuestionModel, in section: SectionModel) -> Binding<String> {
        guard let sectionIndex = viewModel.sections.firstIndex(where: { $0.id == section.id }),
              let questionIndex = viewModel.sections[sectionIndex].questions.firstIndex(where: { $0.id == question.id }) else {
            return .constant("")
        }
        
        return Binding(
            get: {
                let answer: String = (viewModel.sections[sectionIndex].questions[questionIndex].answer.first ?? "")
                return answer
            },
            set: { newValue in
                viewModel.sections[sectionIndex].questions[questionIndex].answer = [newValue]

                if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.sections[sectionIndex].questions[questionIndex].errMsg = ""
                }
            }
        )
    }
}
