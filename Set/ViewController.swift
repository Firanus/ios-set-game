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
    var constants: CardSizeConstants {
        return CardSizeConstants(forViewBounds: gameView.bounds, cardCount: game.cardsInPlay.count)
    }
    
    let deckLocation = CGPoint(x: 100, y: 100)
    var cardViews = [Card: SetCardView]()
    
    func getCardView(for card: Card) -> SetCardView {
        if cardViews[card] == nil {
            cardViews[card] = makeCardViewFromCard(card)
        }
        return cardViews[card] ?? SetCardView()
    }
    
    func location(for card: Card) -> CGPoint {
        return getCardView(for: card).frame.origin
    }
    
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
            for cardView in cardViews.values {
                if cardView.frame.contains(touchLocation) {
                    let cards = cardViews.keysForValue(value: cardView)
                    if cards.count == 1 {
                        game.chooseCard(cards[0])
                        updateViewFromModel()
                    } else {
                        assertionFailure("There is not a 1 to 1 relationship between cards and cardViews")
                    }
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
        
        for subUIView in gameView.subviews {
            subUIView.removeFromSuperview()
        }
        
        for (index,card) in game.cardsInPlay.enumerated() {
            outlineCard(card)
            positionCard(card, rowIndex: index / constants.columnCount, columnIndex: index % constants.columnCount)
        }
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
        
        cardView.frame.origin = deckLocation
        cardView.frame.size = CGSize.zero
        
        return cardView
    }
    
    private func outlineCard(_ card: Card) {
        let cardView = getCardView(for: card)
        if game.selectedCards.contains(card) {
            if game.matchedCards.contains(card) {
                cardView.outlineColor = UIColor.green
            } else if game.selectedCards.count == 3 {
                cardView.outlineColor = UIColor.red
            } else {
                cardView.outlineColor = UIColor.blue
            }
        } else {
            cardView.outlineColor = nil
        }
    }
    
    private func positionCard(_ card: Card, rowIndex row: Int, columnIndex column: Int) {
        let cardView = getCardView(for: card)
        
        let xOrigin = gameView.bounds.origin.x + CGFloat(column) * constants.cardWidth + (2 * CGFloat(column) + 1) * constants.horizontalCardSeperation
        let yOrigin = gameView.bounds.origin.y + CGFloat(row) * constants.cardHeight + (2 * CGFloat(row) + 1) * constants.verticalCardSeperation
        
        cardView.alpha = 1
        cardView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
        cardView.frame.size = CGSize(width: constants.cardWidth, height: constants.cardHeight)
        
        gameView.addSubview(cardView)
    }
}


extension Dictionary where Value: Equatable {
    /// Returns all keys mapped to the specified value.
    /// ```
    /// let dict = ["A": 1, "B": 2, "C": 3]
    /// let keys = dict.keysForValue(2)
    /// assert(keys == ["B"])
    /// assert(dict["B"] == 2)
    /// ```
    func keysForValue(value: Value) -> [Key] {
        return flatMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}
