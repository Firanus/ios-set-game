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
    var cardConstants: CardSizeConstants {
        return CardSizeConstants(forViewBounds: CGRect(
            x: gameView.bounds.origin.x,
            y: gameView.bounds.origin.y,
            width: gameView.bounds.width,
            height: gameView.bounds.height * (1 - bottomViewToBoundsHeightRatio)
        ), cardCount: game.cardsInPlay.count)
    }
    let bottomViewToBoundsHeightRatio: CGFloat = 0.1
    lazy var deckConstants = DeckSizeConstants(forViewBounds:
        CGRect(
            x: gameView.bounds.origin.x,
            y: gameView.bounds.origin.y + gameView.bounds.height * (1 - bottomViewToBoundsHeightRatio),
            width: gameView.bounds.width,
            height: gameView.bounds.height * bottomViewToBoundsHeightRatio))
    
    var deckView: SetCardView?
    var discardPileView: SetCardView?
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
//    @IBOutlet weak var bottomButton: UIButton!
//    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var gameView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(drawCards))
            swipe.direction = .down
            gameView.addGestureRecognizer(swipe)
        }
    }
    
//    @IBAction func touchBottomButton(_ sender: UIButton) {
//        if game.isComplete {
//            game = Set()
//            updateViewFromModel()
//        } else if game.unPlayedCards.count > 0 {
//            drawCards()
//        }
//    }
    
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
        
        
        for subUIView in gameView.subviews {
            subUIView.removeFromSuperview()
        }
        
        drawDecks()
        
        var newCardCount = 0
        for (index,card) in game.cardsInPlay.enumerated() {
            let cardView = getCardView(for: card)
            outlineCard(card)
            if cardView.frame.origin == deckView?.frame.origin { newCardCount += 1 }
            let animationDelay = TimeInterval(newCardCount) * animationConstants.drawingAnimationDuration
            positionCard(card, rowIndex: index / cardConstants.columnCount, columnIndex: index % cardConstants.columnCount, animationDelay: animationDelay)
        }
    }
    
//    private func drawBottomButton() {
//        if game.isComplete {
//            bottomButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            bottomButton.setTitle("Start a New Game", for: UIControlState.normal)
//        } else if game.unPlayedCards.count > 0 {
//            bottomButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            bottomButton.setTitle("Draw 3 Cards", for: UIControlState.normal)
//        } else {
//            bottomButton.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            bottomButton.setTitle("", for: UIControlState.normal)
//        }
//    }
    
    private func drawDecks() {
        if !game.unPlayedCards.isEmpty {
            deckView = SetCardView()
            deckView!.frame = deckConstants.deckRect
            gameView.addSubview(deckView!)
        } else {
            if let visibleDeckView = deckView {
                visibleDeckView.removeFromSuperview()
                deckView = nil
            }
        }
        
        if !game.matchedCards.isEmpty {
            discardPileView = SetCardView()
            discardPileView!.frame = deckConstants.discardPileRect
            gameView.addSubview(discardPileView!)
        } else {
            if let visibleDiscardPile = discardPileView {
                visibleDiscardPile.removeFromSuperview()
                discardPileView = nil
            }
        }
        gameView.setNeedsDisplay()
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
        
        
        cardView.frame = deckView?.frame ?? CGRect.zero
        
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
    
    private func positionCard(_ card: Card, rowIndex row: Int, columnIndex column: Int, animationDelay: TimeInterval = 0.0) {
        let cardView = getCardView(for: card)
        
        let xOrigin = gameView.bounds.origin.x + CGFloat(column) * cardConstants.cardWidth + (2 * CGFloat(column) + 1) * cardConstants.horizontalCardSeperation
        let yOrigin = gameView.bounds.origin.y + CGFloat(row) * cardConstants.cardHeight + (2 * CGFloat(row) + 1) * cardConstants.verticalCardSeperation
        let cardSize = CGSize(width: cardConstants.cardWidth, height: cardConstants.cardHeight)
        
        cardView.alpha = 1
        
        if cardView.frame.origin == deckView?.frame.origin {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: animationConstants.drawingAnimationDuration,
                delay: animationDelay,
                options: [],
                animations: {
                    cardView.transform = CGAffineTransform.identity
                    if cardView.frame.width > cardView.frame.height {
                        cardView.transform = cardView.transform.rotated(by: CGFloat.pi / 2)
                    }
                    cardView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                    cardView.frame.size = cardSize
                }, completion: { finished in
                    if !cardView.isFaceUp {
                        UIView.transition(
                            with: cardView,
                            duration: animationConstants.flippingAnimationDuration,
                            options: [.transitionFlipFromLeft],
                            animations: {
                                cardView.isFaceUp = true
                        })
                    }
            })
        } else if cardView.frame.origin != CGPoint(x: xOrigin, y: yOrigin) {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: animationConstants.drawingAnimationDuration,
                delay: 0,
                options: [],
                animations: {
                    cardView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                    cardView.frame.size = cardSize
            })
        }
        
        gameView.addSubview(cardView)
    }
    
    struct animationConstants {
        static let drawingAnimationDuration: TimeInterval = 0.6
        static let flippingAnimationDuration: TimeInterval = 0.5
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
