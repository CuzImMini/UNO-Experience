//
//  Card.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 25.01.23.
//

import Foundation

class Card: Identifiable, Equatable, ObservableObject, Codable {

    static func ==(lhs: Card, rhs: Card) -> Bool {
        lhs.type == rhs.type && lhs.id == rhs.id
    }


    var id: Int
    var type: Cards

    var rotationRadian: Double?

    init(id: Int, type: Cards) {
        self.id = id
        self.type = type
    }

    init(id: Int, type: Cards, rotationRadian: Double) {
        self.id = id
        self.type = type
        self.rotationRadian = rotationRadian
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

    static func getRandom(id: Int, sessionHandler: MP_Session) -> Card {

        if sessionHandler.cardProbabilityDeck == [] {
            sessionHandler.cardProbabilityDeck = self.getRealDeck()
        }

        let cardType = sessionHandler.cardProbabilityDeck.randomElement() ?? .BLUE_ONE

        sessionHandler.cardProbabilityDeck.remove(at: sessionHandler.cardProbabilityDeck.firstIndex(where: { $0 == cardType })!)

        let card = Card(id: id, type: cardType)

        return card

    }

    static func getRandom(amount: Int, sessionHandler: MP_Session) -> [Card] {
        var array: [Card] = []
        let range = 0...(amount - 1)

        for i in range {

            let card = getRandom(id: i, sessionHandler: sessionHandler)

            array.append(card)

        }

        return array


    }

    static func getRealDeck() -> [Cards] {


        var realArray: [Cards] = []

        for _ in 1...5 {
            realArray.append(.CHOOSE)
        }

        for card in Cards.allCases {
            if card.number > -1 && card.number < 10 {
                realArray.append(card)
            }
        }

        realArray.append(.GREENDRAWTWO)
        realArray.append(.YELLOWDRAWTWO)
        realArray.append(.BLUEDRAWTWO)
        realArray.append(.REDDRAWTWO)

        realArray.append(.YFORCESKIP)
        realArray.append(.BFORCESKIP)
        realArray.append(.GFORCESKIP)
        realArray.append(.RFORCESKIP)


        return realArray

    }


}