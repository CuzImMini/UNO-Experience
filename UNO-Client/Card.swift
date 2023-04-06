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

}
