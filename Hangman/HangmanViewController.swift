//
//  ViewController.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var guesses: UILabel!
    @IBOutlet weak var hangmanState: UIImageView!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var phraseLabel: UILabel!
    let limitLength = 1
    let hangman = Hangman()
    var gameStarted = false
    var wrongGuesses = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardNotification:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardNotification:"), name:UIKeyboardWillHideNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        
        let isShowing = notification.name == UIKeyboardWillShowNotification
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let endFrameHeight = endFrame?.size.height ?? 0.0
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.bottomSpacingConstraint?.constant = isShowing ? endFrameHeight : 0.0
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    @IBAction func newGamePressed(sender: AnyObject) {
        startNewGame()
    }
    
    func startNewGame() {
        hangman.start()
        phraseLabel.text = hangman.knownString
        hangmanState.image = UIImage(named: "hangman" + String(wrongGuesses) + ".gif")
        gameStarted = true
        guesses.text = hangman.incorrect()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if text.characters.count == 1 {
            textField.text = string
        }
        return newLength <= limitLength
    }
    
    @IBAction func guessPressed(sender: AnyObject) {
        if gameStarted {
            let guessText = textField.text?.uppercaseString
            if hangman.guessLetter(guessText!) {
                phraseLabel.text = hangman.knownString
                if hangman.knownString == hangman.answer {
                    wrongGuesses = 1
                    let winAlert = UIAlertController(title: "You win!", message: "Would you like to start another game?", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    winAlert.addAction(UIAlertAction(title: "Start Over", style: .Default, handler: { (action: UIAlertAction!) in
                        self.startNewGame();
                    }))
                    
                    presentViewController(winAlert, animated: true, completion: nil)
                }
            
            } else {
                wrongGuesses += 1
                hangmanState.image = UIImage(named: "hangman" + String(wrongGuesses) + ".gif")
                guesses.text = hangman.incorrect()
                if wrongGuesses == 7 {
                    wrongGuesses = 1
                    let loseAlert = UIAlertController(title: "You lose!", message: "Would you like to start another game? The word was: " + hangman.answer!, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    loseAlert.addAction(UIAlertAction(title: "Start Over", style: .Default, handler: { (action: UIAlertAction!) in
                        self.startNewGame();
                    }))
                    
                    presentViewController(loseAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guessPressed(textField)
        return false
    }
}

