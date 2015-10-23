//
//  Hangman.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import Foundation

class Hangman {
    var phrases: HangmanPhrase!
    var answer: String?
    var knownString: String?
    var guessedLetters: NSMutableArray?
    
    // Initialize HangmanPhrase with all possible phrases of Hangman game
    init() {
        phrases = HangmanPhrase()
    }
    
    // Start the game, selecting a phrase from phrases. Also sets up the current known string
    // and guessedLetters array
    func start() {
        let phrase = phrases.getRandomPhrase()
        answer = phrase
        knownString = ""
        for (var i = 0; i < answer!.characters.count; i += 1) {
            if (phrase as NSString).substringWithRange(NSMakeRange(i, 1)) == " " {
                knownString = knownString! + " "
            } else {
                knownString = knownString! + "_"
            }
        }
        guessedLetters = NSMutableArray()
    }
    
    // Guess a letter, adding that letter to guessedLetters, and checking that letter against
    // the answer phrase. Returns whether or not the guess is correct.
    func guessLetter(letter: String) -> Bool {
        var isCorrect = false
        if guessedLetters!.containsObject(letter) {
            return true
        }
        guessedLetters!.addObject(letter)
        var chars = Array(answer!.characters)
        
        for (var i = 0; i < answer!.characters.count; i += 1) {
            if String(chars[i]) == letter {
                isCorrect = true
                knownString = "\((knownString! as NSString).substringToIndex(i))" + "\(letter)"
                            + "\((knownString! as NSString).substringFromIndex(i+1))"
            }
        }
        return isCorrect
    }
    
    // Return a string of all letter guesses so far
    func guesses() -> String {
        if guessedLetters!.count == 0 {
            return ""
        }
        var result: String!
        for (var i = 0; i < guessedLetters!.count; i += 1) {
            result = result + ", \(guessedLetters?.objectAtIndex(i))"
        }
        return result
    }

}