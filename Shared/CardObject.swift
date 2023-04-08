//
//  Card.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 25.01.23.
//

import Foundation

class Card: Identifiable, Equatable, ObservableObject, Codable {

    //Mache Karten vergleichbar
    static func ==(lhs: Card, rhs: Card) -> Bool {
        lhs.type == rhs.type && lhs.id == rhs.id
    }

    //Card variables
    var id: Int
    var type: Cards

    //Optional variable for animation purpose
    var rotationDegree: Int?

    //Card init
    init(id: Int, type: Cards) {
        self.id = id
        self.type = type
    }

    init(id: Int, type: Cards, rotationDegree: Int) {
        self.id = id
        self.type = type
        self.rotationDegree = rotationDegree
    }


    //Get Random card with id from Probability-Deck
    static func getRandom(id: Int, sessionHandler: HostSessionManager) -> Card {

        if sessionHandler.gameHandler.cardProbabilityDeck == [] {
            sessionHandler.gameHandler.cardProbabilityDeck = self.getRealDeck()
        }

        let cardType = sessionHandler.gameHandler.cardProbabilityDeck.randomElement() ?? .BLUE_ONE

        sessionHandler.gameHandler.cardProbabilityDeck.remove(at: sessionHandler.gameHandler.cardProbabilityDeck.firstIndex(where: { $0 == cardType })!)

        let card = Card(id: id, type: cardType)

        return card

    }
    

    //Get Random Deck with Cards from probability Deck
    static func getRandom(amount: Int, sessionHandler: HostSessionManager) -> [Card] {
        var array: [Card] = []
        let range = 0...(amount - 1)

        for i in range {

            let card = getRandom(id: i, sessionHandler: sessionHandler)

            array.append(card)

        }

        return array


    }

    //Create a whole new Deck with the right Uno-Card-ratio
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
