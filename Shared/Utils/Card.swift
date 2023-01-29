//
//  Card.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 25.01.23.
//

import Foundation

class Card: Identifiable, Equatable, ObservableObject {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        lhs.type == rhs.type && lhs.id == rhs.id
    }


    var id: Int
    var type: Cards

    init(id: Int, type: Cards) {
        self.id = id
        self.type = type
    }

    static func getRandom(amount: Int) -> [Card] {
        var array: [Card] = []
        let range = 0...(amount - 1)

        for i in range {

            let card = getRandom(id: i)

            array.append(card)

        }

        return array


    }

    static func getRandom(id: Int) -> Card {
        let card = Card(id: id, type: Cards.allCases.randomElement() ?? .BLUE_ONE)

        if card.type == .Y_CHOOSE || card.type == .R_CHOOSE || card.type == .G_CHOOSE || card.type == .B_CHOOSE {
            return getRandom(id: id)
        } else {
            return card
        }
    }


}
