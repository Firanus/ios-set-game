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
    var cardViews = [SetCardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var gameView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(drawCards))
            swipe.direction = .down
            gameView.addGestureRecognizer(swipe)
        }
    }
    
    @IBAction func touchBottomButton(_ sender: UIButton) {
        if game.isComplete {
            game = Set()
            updateViewFromModel()
        } else if game.unPlayedCards.count > 0 {
            drawCards()
        }
    }
    
    @IBAction func tapCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let touchLocation = sender.location(in: gameView)
            for (index, card) in cardViews.enumerated() {
                if card.frame.contains(touchLocation) {
                    game.chooseCard(at: index)
                    updateViewFromModel()
                }
            }
        default:
            break
        }
    }
    
    @IBAction func rotateGameView(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffleCardsInPlay()
            updateViewFromModel()
        default:
            break
        }
    }
    
    @objc func drawCards() {
        game.drawMultipleCards(number: 3)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        
        drawBottomButton()
        
        cardViews = []
        
        for card in game.cardsInPlay {
            let cardView = makeCardViewFromCard(card)
            cardViews.append(cardView)
        }
        
        arrangeCardViews()
    }
    
    private func drawBottomButton() {
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
    }
    
    private func makeCardViewFromCard(_ card: Card) -> SetCardView {
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
        
        if game.selectedCards.contains(card) {
            if game.matchedCards.contains(card) {
                cardView.selectedColor = UIColor.green
            } else if game.selectedCards.count == 3 {
                cardView.selectedColor = UIColor.red
            } else {
                cardView.selectedColor = UIColor.blue
            }
        } else {
            cardView.selectedColor = nil
        }
        return cardView
    }
    
    private func arrangeCardViews() {
        for subUIView in gameView.subviews {
            subUIView.removeFromSuperview()
        }
        
        let constants = CardSizeConstants(forViewBounds: gameView.bounds, cardCount: cardViews.count)
        
        for row in 0..<constants.rowCount {
            for column in 0..<constants.columnCount {
                if row * constants.columnCount + column < cardViews.count {
                    let card = cardViews[row * constants.columnCount + column]
                    let xOrigin = gameView.bounds.origin.x + CGFloat(column) * constants.cardWidth + (2 * CGFloat(column) + 1) * constants.horizontalCardSeperation
                    let yOrigin = gameView.bounds.origin.y + CGFloat(row) * constants.cardHeight + (2 * CGFloat(row) + 1) * constants.verticalCardSeperation
                    card.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                    card.frame.size = CGSize(width: constants.cardWidth, height: constants.cardHeight)
                    card.alpha = 1
                    gameView.addSubview(card)
                }
            }
        }
    }
}
