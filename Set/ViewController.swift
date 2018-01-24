//
//  ViewController.swift
//  Set
//
//  Created by Ivan Tchernev on 23/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = Set()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            game.chooseCard(at: index)
            updateViewFromModel()
        } else {
            print("This card is not part of the cards array")
        }
    }
    
    @IBAction func touchBottomButton(_ sender: UIButton) {
        if game.isComplete {
            game = Set()
        } else if game.cardsInPlay.count < cardButtons.count {
            game.drawCards()
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        
        if game.isComplete {
            bottomButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            bottomButton.setTitle("Start a New Game", for: UIControlState.normal)
        } else if game.cardsInPlay.count < cardButtons.count {
            bottomButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            bottomButton.setTitle("Draw 3 Cards", for: UIControlState.normal)
        } else {
            bottomButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            bottomButton.setTitle("", for: UIControlState.normal)
        }
        
        for (index, button) in cardButtons.enumerated() {
            if let card = index < game.cardsInPlay.count ? game.cardsInPlay[index] : nil {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setAttributedTitle(getSymbolFor(card: card), for: UIControlState.normal)
                
                if game.selectedCards.contains(card) {
                    button.layer.borderWidth = 3.0
                    if game.matchedCards.contains(card) {
                        button.layer.borderColor = UIColor.green.cgColor
                    } else if game.selectedCards.count == 3 {
                        button.layer.borderColor = UIColor.red.cgColor
                    } else {
                        button.layer.borderColor = UIColor.blue.cgColor
                    }
                } else {
                    button.layer.borderWidth = 0.0
                    button.layer.borderColor = UIColor.white.cgColor
                }
            } else {
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.setAttributedTitle(NSAttributedString(), for: UIControlState.normal)
                button.layer.borderWidth = 0.0
                button.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    var cardSymbols = [Card:NSAttributedString]()
    
    func getSymbolFor(card: Card) -> NSAttributedString {
        if cardSymbols[card] == nil {
            var attributes: [NSAttributedStringKey : Any] = [:]
            var color: UIColor
            
            switch card.color {
            case Card.CardProperty.primary:
                    color = UIColor.red
            case Card.CardProperty.secondary:
                    color = UIColor.green
            case Card.CardProperty.tertiary:
                    color = UIColor.blue
            }
            
            switch card.shading {
            case Card.CardProperty.primary:
                attributes[.foregroundColor] = color.withAlphaComponent(1.0)
            case Card.CardProperty.secondary:
                attributes[.foregroundColor] = color.withAlphaComponent(0.15)
            case Card.CardProperty.tertiary:
                attributes[.strokeColor] = color
                attributes[.strokeWidth] = 3.0
            }
            
            var proposedText = ""
            switch (card.number, card.shape) {
            case (Card.CardProperty.primary, Card.CardProperty.primary):
                proposedText = "▲"
            case (Card.CardProperty.primary, Card.CardProperty.secondary):
                proposedText = "▲▲"
            case (Card.CardProperty.primary, Card.CardProperty.tertiary):
                proposedText = "▲▲▲"
            case (Card.CardProperty.secondary, Card.CardProperty.primary):
                proposedText = "●"
            case (Card.CardProperty.secondary, Card.CardProperty.secondary):
                proposedText = "●●"
            case (Card.CardProperty.secondary, Card.CardProperty.tertiary):
                proposedText = "●●●"
            case (Card.CardProperty.tertiary, Card.CardProperty.primary):
                proposedText = "■"
            case (Card.CardProperty.tertiary, Card.CardProperty.secondary):
                proposedText = "■■"
            case (Card.CardProperty.tertiary, Card.CardProperty.tertiary):
                proposedText = "■■■"
            }
            cardSymbols[card] = NSAttributedString(string: proposedText, attributes: attributes)
        }
        return cardSymbols[card] ?? NSAttributedString()
    }
}
