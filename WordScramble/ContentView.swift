//
//  ContentView.swift
//  WordScramble
//
//  Created by Nicolas Papegaey on 29/05/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $viewModel.newWord)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                
                Section {
                    ForEach(viewModel.usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        .accessibilityElement()
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count) letters")
                    }
                }
                Text("Score: \(viewModel.score)")
            }

            .navigationTitle(viewModel.rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: viewModel.startGame)
            .alert(viewModel.errorTitle, isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
            .toolbar {
                Button("New word", action: viewModel.startGame)
            }
        }
    }
    
    func addNewWord() {
        let answer = viewModel.newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard viewModel.isOriginal(word: answer) else {
            viewModel.wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard viewModel.isPossible(word: answer) else {
            viewModel.wordError(title: "Word not possible", message: "You can't spell that word from '\(viewModel.rootWord)'!")
            return
        }
        
        guard viewModel.isReal(word: answer) else {
            viewModel.wordError(title: "Word not recognized", message: "You can't juste make them up, you know!")
            return
        }
        
        guard viewModel.isLongEnough(word: answer) else {
            viewModel.wordError(title: "Word too small", message: "Your word must contain at least 3 letters!")
            return
        }
        
        withAnimation {
            viewModel.usedWords.insert(answer, at: 0)
        }
        viewModel.score+=answer.count
        viewModel.newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
