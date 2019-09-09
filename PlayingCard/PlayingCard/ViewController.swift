//
//  ViewController.swift
//  PlayingCard
//
//  Created by Andy Smith on 8/16/19.
//  Copyright © 2019 Andy Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var deck = PlayingCardDeck()

  @IBOutlet var cardViews: [PlayingCardView]!
  
  lazy var animator = UIDynamicAnimator(referenceView: self.view)
  
  lazy var collisionBehaviour: UICollisionBehavior = {
    let behaviour = UICollisionBehavior()
    behaviour.translatesReferenceBoundsIntoBoundary = true
    animator.addBehavior(behaviour)
    return behaviour
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var cards = [PlayingCard]()
    
    for _ in 1...((cardViews.count+1)/2) {
      let card = deck.draw()!
      cards += [card, card]
    }
    for cardView in cardViews {
      cardView.isFaceUp = false
      let card = cards.remove(at: cards.count.arc4random)
      cardView.rank = card.rank.order
      cardView.suit = card.suit.rawValue
      cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
      collisionBehaviour.addItem(cardView)
      let push = UIPushBehavior(items: [cardView], mode: .instantaneous)
//      push.angle = (2*CGFloat.pi).arc4random
//      push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
      push.action = { [unowned push] in
        push.dynamicAnimator?.removeBehavior(push)
      }
      animator.addBehavior(push)
    }
  }
  
  private var faceUpCardViews: [PlayingCardView] {
    return cardViews.filter { $0.isFaceUp && !$0.isHidden}
  }
  
  private var faceUpCardViewsMatch: Bool {
    return faceUpCardViews.count == 2 &&
      faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
      faceUpCardViews[0].suit == faceUpCardViews[0].suit
  }
  
  @IBAction @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
    switch recognizer.state {
    case .ended:
      if let chosenCardView = recognizer.view as? PlayingCardView {
        UIView.transition(with: chosenCardView,
                          duration: 0.6,
                          options: [.transitionFlipFromLeft],
                          animations: {
                              chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                          },
                          completion: { finished in
                            
                            if self.faceUpCardViewsMatch {
                              UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                               delay: 0,
                               options: [],
                               animations: {
                                self.faceUpCardViews.forEach({
                                  $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                })
                              },
                              completion: { position in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                  withDuration: 0.75,
                                  delay: 0,
                                  options: [],
                                  animations: {
                                    self.faceUpCardViews.forEach({
                                      $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                      $0.alpha = 0
                                    })
                                },
                                  completion: { position in
                                    self.faceUpCardViews.forEach({
                                      $0.isHidden = true
                                      $0.alpha = 1
                                      $0.transform = .identity
                                    })

                                }
                                )

                              }
                              )
                            } else if self.faceUpCardViews.count == 2 {
                              self.faceUpCardViews.forEach { cardView in
                                UIView.transition(with: cardView,
                                                  duration: 0.6,
                                                  options: [.transitionFlipFromLeft],
                                                  animations: {
                                                    cardView.isFaceUp = false
                                                  })

                              }
                            }

                          }
        )
      }
    default:break
    }
  }

  
  @IBOutlet weak var playingCardView: PlayingCardView! {
    didSet {
      let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
      swipe.direction = [.left, .right]
      playingCardView.addGestureRecognizer(swipe)
      let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy: )))
      playingCardView.addGestureRecognizer(pinch)
    }
  }
  
  @objc func nextCard() {
    if let card = deck.draw() {
      playingCardView.rank = card.rank.order
      playingCardView.suit = card.suit.rawValue
    }
  }
  

    
  


}

