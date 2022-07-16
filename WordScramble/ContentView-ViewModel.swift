//
//  ContentView-ViewModel.swift
//  WordScramble
//
//  Created by Nicolas Papegaey on 16/07/2022.
//

import Foundation
import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var usedWords = [String]()
        @Published var rootWord = ""
        @Published var newWord = ""
        
        @Published var errorTitle = ""
        @Published var errorMessage = ""
        @Published var showingError = false
        
        @Published var score = 0
        
        func startGame() {
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                if let startWords = try? String(contentsOf: startWordsURL) {
                    let allWords = startWords.components(separatedBy: "\n")
                    rootWord = allWords.randomElement() ?? "silkworm"
                    return
                }
            }
            fatalError("Could not load start.txt from bundle.")
        }
        
        func isOriginal(word: String) -> Bool {
            !usedWords.contains(word)
        }
        
        func isPossible(word: String) -> Bool {
            var tempWord = rootWord
            for letter in word {
                print("letter: \(letter)")
                if let pos = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: pos)
                } else {
                    return false
                }
            }
            
            return true
        }
        
        func isReal(word: String) -> Bool {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            
            return misspelledRange.location == NSNotFound
        }
        
        func isLongEnough(word: String) -> Bool {
            word.count >= 3
        }
        
        func wordError(title: String, message: String) {
            errorTitle = title
            errorMessage = message
            showingError = true
        }
    }
}




