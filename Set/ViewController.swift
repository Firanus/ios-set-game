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
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var gameView: SetGameView! {
        didSet {
            //set gestures in here
        }
    }
    
    @IBAction func touchBottomButton(_ sender: UIButton) {
        if game.isComplete {
            game = Set()
            updateViewFromModel()
        } else if game.unPlayedCards.count > 0 {
            game.drawMultipleCards(number: 3)
            updateViewFromModel()
        }
    }
    
    func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        
        if game.isComplete {
            bottomButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            bottomButton.setTitle("Start a New Game", for: UIControlState.normal)
        } else if game.unPlayedCards.count > 0 {
            bottomButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            bottomButton.setTitle("Draw 3 Cards", for: UIControlState.normal)
        } else {
            bottomButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            bottomButton.setTitle("", for: UIControlState.normal)
        }

        var cardViews = [SetCardView]()
        for card in game.cardsInPlay {
            let cardView = SetCardView()
            
            cardView.number = card.number.rawValue
            
            switch card.color {
            case Card.CardProperty.primary:
                    cardView.color = UIColor.red
            case Card.CardProperty.secondary:
                    cardView.color = UIColor.green
            case Card.CardProperty.tertiary:
                    cardView.color = UIColor.blue
            }
            
            switch card.shading {
            case Card.CardProperty.primary:
                cardView.shading = SetCardView.CardShading.outline
            case Card.CardProperty.secondary:
                cardView.shading = SetCardView.CardShading.striped
            case Card.CardProperty.tertiary:
                cardView.shading = SetCardView.CardShading.solid
            }
            
            switch card.shape {
            case Card.CardProperty.primary:
                cardView.shape = SetCardView.CardShape.diamond
            case Card.CardProperty.secondary:
                cardView.shape = SetCardView.CardShape.squiggle
            case Card.CardProperty.tertiary:
                cardView.shape = SetCardView.CardShape.oval
            }
            cardViews.append(cardView)
        }
        gameView.cardViews = cardViews
    }
}
