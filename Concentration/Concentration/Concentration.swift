//
//  Concentration.swift
//  Concentration
//
//  Created by Andy Smith on 8/14/19.
//  Copyright © 2019 Andy Smith. All rights reserved.
//

import Foundation

struct Concentration {
  private(set) var cards = [Card]()
  
  private var indexOfOneAndOnlyFaceUpCard: Int? {
    get {
      return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
    }
    set {
      for index in cards.indices {
        cards[index].isFaceUp = (index == newValue)
      }
    }
  }
  
  init(numberOfPairsOfCards: Int) {
    assert(numberOfPairsOfCards > 0, "Concentration.init, must have one pair of cards")
    for _ in 1...numberOfPairsOfCards {
      let card = Card()
      cards += [card, card]
    }
    cards.shuffle()
  }
  
  mutating func chooseCard(at index: Int) {
    assert(cards.indices.contains(index), "Concentration.chooseCard(atP \(index)): chosen index not in the cards")
    if !cards[index].isMatched {
      if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
        if cards[matchIndex] == cards[index] {
          cards[matchIndex].isMatched = true
          cards[index].isMatched = true
        }
        cards[index].isFaceUp = true
      } else {
        indexOfOneAndOnlyFaceUpCard = index
      }
    }
  }
}

extension Collection {
  var oneAndOnly: Element? {
    return count == 1 ? first : nil
  }
}
