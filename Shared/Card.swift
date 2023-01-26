//
//  Card.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 25.01.23.
//

import Foundation

struct Card: Identifiable {

    var id: Int
    var type: Cards
    var visible: Bool = true

    static func getRandom(amount: Int) -> [Self] {
        var array: [Card] = []
        let range = 0...amount

        for i in range {

            var card = getRandom(id: i)

            array.append(card)

        }

        return array


    }

    static func getRandom(id: Int) -> Self {
        var card = Card(id: id, type: Cards.allCases.randomElement() ?? .BLUE_ONE)

        if card.type != .Y_CHOOSE || card.type != .R_CHOOSE || card.type != .G_CHOOSE || card.type != .B_CHOOSE {
            return card
        } else {
            return getRandom(id: id)
        }
    }

}
