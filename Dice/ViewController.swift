//
//  ViewController.swift
//  Dice

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    @IBOutlet weak var btnRoll: UIButton!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblLives: UILabel!
    
    let kRotationAnimationKey = "com.dice" 
    var score = 0
    var live = 10
    
    
    override func viewDidLoad() {
        btnRoll.layer.cornerRadius = 20
        lblScore.text = String(format: "Score:%d", score)
        lblLives.text = String(format: "Live:%d", live)
        btnRoll.layer.cornerRadius = 18
        btnRoll.layer.borderWidth = 2
        btnRoll.layer.borderColor = UIColor.white.cgColor
    }
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        
        if live == 0 {
            showAlert()
        }
        else {
            rotateView(view: diceImageView1)
            rotateView(view: diceImageView2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.stopRotatingView(view: self.diceImageView1, another: self.diceImageView2)
            })
        }
    }
    func rotateView(view: UIView, duration: Double = 1) {
        if view.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float(.pi * 4.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    func stopRotatingView(view: UIView, another:UIView) {
        if view.layer.animation(forKey: kRotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
        if another.layer.animation(forKey: kRotationAnimationKey) != nil {
            another.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
        updateDice()
    }
    func updateDice() {
        let diceArray = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
        diceImageView1.image = diceArray[Int.random(in: 0...5)]
        diceImageView2.image = diceArray[Int.random(in: 0...5)]
        
        if diceImageView1.image == diceImageView2.image {
            score += 1
        }
        else {
            if live == 0 {
                showAlert()
            }
            else {
                live = live - 1
            }
        }
        
        lblScore.text = String(format: "Score:%d", score)
        lblLives.text = String(format: "Live:%d", live)
    }
    func showAlert()
    {
        let alert = UIAlertController(title: "Game Over", message: "You Lose!\nBetter Luck Next Time!", preferredStyle: .actionSheet)
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .destructive, handler: handleTryAgainActionAlertAction)
        alert.addAction(tryAgainAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: 1, height: 1)
        self.present(alert, animated: true, completion: nil)
    }
    func handleTryAgainActionAlertAction(alertAction: UIAlertAction!) -> Void
    {
        score = 0
        live = 10
        
        lblScore.text = String(format: "Score:%d", score)
        lblLives.text = String(format: "Live:%d", live)
    }
}

