//
//  GameEnums.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//

import Foundation
import SwiftUI


enum ViewStates: String {

    case mainMenu = "mainmenu"
    case inGame = "ingame"
    case loose = "loose"
    case win = "win"

}

enum GameStates: String {

    case running = "running"
    case noGame = "nogame"

}

enum GameTraffic: String {

    case startGame = "gamestart"
    case stopGame = "gamestop"
    case win = "win"
    case skip = "skip"

}

enum Cards: String, CaseIterable {


    case RED_ZERO = "Red 0"
    case RED_ONE = "Red 1"
    case RED_TWO = "Red 2"
    case RED_THREE = "Red 3"
    case RED_FOUR = "Red 4"
    case RED_FIVE = "Red 5"
    case RED_SIX = "Red 6"
    case RED_SEVEN = "Red 7"
    case RED_EIGHT = "Red 8"
    case RED_NINE = "Red 9"
    case BLUE_ZERO = "Blue 0"
    case BLUE_ONE = "Blue 1"
    case BLUE_TWO = "Blue 2"
    case BLUE_THREE = "Blue 3"
    case BLUE_FOUR = "Blue 4"
    case BLUE_FIVE = "Blue 5"
    case BLUE_SIX = "Blue 6"
    case BLUE_SEVEN = "Blue 7"
    case BLUE_EIGHT = "Blue 8"
    case BLUE_NINE = "Blue 9"
    case GREEN_ZERO = "Green 0"
    case GREEN_ONE = "Green 1"
    case GREEN_TWO = "Green 2"
    case GREEN_THREE = "Green 3"
    case GREEN_FOUR = "Green 4"
    case GREEN_FIVE = "Green 5"
    case GREEN_SIX = "Green 6"
    case GREEN_SEVEN = "Green 7"
    case GREEN_EIGHT = "Green 8"
    case GREEN_NINE = "Green 9"
    case YELLOW_ZERO = "Yellow 0"
    case YELLOW_ONE = "Yellow 1"
    case YELLOW_TWO = "Yellow 2"
    case YELLOW_THREE = "Yellow 3"
    case YELLOW_FOUR = "Yellow 4"
    case YELLOW_FIVE = "Yellow 5"
    case YELLOW_SIX = "Yellow 6"
    case YELLOW_SEVEN = "Yellow 7"
    case YELLOW_EIGHT = "Yellow 8"
    case YELLOW_NINE = "Yellow 9"
    case CHOOSE = "Choose"
    case Y_CHOOSE = "Y Choose"
    case G_CHOOSE = "G Choose"
    case R_CHOOSE = "R Choose"
    case B_CHOOSE = "B Choose"

    var description: String {
        switch self {
        case .RED_ZERO: return "Rot 0"
        case .RED_ONE: return "Rot 1"
        case .RED_TWO: return "Rot 2"
        case .RED_THREE: return "Rot 3"
        case .RED_FOUR: return "Rot 4"
        case .RED_FIVE: return "Rot 5"
        case .RED_SIX: return "Rot 6"
        case .RED_SEVEN: return "Rot 7"
        case .RED_EIGHT: return "Rot 8"
        case .RED_NINE: return "Rot 9"
        case .BLUE_ZERO: return "Blau 0"
        case .BLUE_ONE: return "Blau 1"
        case .BLUE_TWO: return "Blau 2"
        case .BLUE_THREE: return "Blau 3"
        case .BLUE_FOUR: return "Blau 4"
        case .BLUE_FIVE: return "Blau 5"
        case .BLUE_SIX: return "Blau 6"
        case .BLUE_SEVEN: return "Blau 7"
        case .BLUE_EIGHT: return "Blau 8"
        case .BLUE_NINE: return "Blau 9"
        case .GREEN_ZERO: return "Grün 0"
        case .GREEN_ONE: return "Grün 1"
        case .GREEN_TWO: return "Grün 2"
        case .GREEN_THREE: return "Grün 3"
        case .GREEN_FOUR: return "Grün 4"
        case .GREEN_FIVE: return "Grün 5"
        case .GREEN_SIX: return "Grün 6"
        case .GREEN_SEVEN: return "Grün 7"
        case .GREEN_EIGHT: return "Grün 8"
        case .GREEN_NINE: return "Grün 9"
        case .YELLOW_ZERO: return "Gelb 0"
        case .YELLOW_ONE: return "Gelb 1"
        case .YELLOW_TWO: return "Gelb 2"
        case .YELLOW_THREE: return "Gelb 3"
        case .YELLOW_FOUR: return "Gelb 4"
        case .YELLOW_FIVE: return "Gelb 5"
        case .YELLOW_SIX: return "Gelb 6"
        case .YELLOW_SEVEN: return "Gelb 7"
        case .YELLOW_EIGHT: return "Gelb 8"
        case .YELLOW_NINE: return "Gelb 9"
        case .CHOOSE: return "Joker"
        case .Y_CHOOSE: return "Gelb gewünscht"
        case .G_CHOOSE: return "Grün gewünscht"
        case .R_CHOOSE: return "Rot gewünscht"
        case .B_CHOOSE: return "Blau gewünscht"


        }
    }

    var color: Color {
        switch self {
        case .RED_ZERO: return Color.red
        case .RED_ONE:
            return Color.red
        case .RED_TWO:
            return Color.red
        case .RED_THREE:
            return Color.red
        case .RED_FOUR:
            return Color.red
        case .RED_FIVE:
            return Color.red
        case .RED_SIX:
            return Color.red
        case .RED_SEVEN:
            return Color.red
        case .RED_EIGHT:
            return Color.red
        case .RED_NINE:
            return Color.red
        case .BLUE_ZERO:
            return Color.blue
        case .BLUE_ONE:
            return Color.blue
        case .BLUE_TWO:
            return Color.blue
        case .BLUE_THREE:
            return Color.blue
        case .BLUE_FOUR:
            return Color.blue
        case .BLUE_FIVE:
            return Color.blue
        case .BLUE_SIX:
            return Color.blue
        case .BLUE_SEVEN:
            return Color.blue
        case .BLUE_EIGHT:
            return Color.blue
        case .BLUE_NINE:
            return Color.blue
        case .GREEN_ZERO:
            return Color.green
        case .GREEN_ONE:
            return Color.green
        case .GREEN_TWO:
            return Color.green
        case .GREEN_THREE:
            return Color.green
        case .GREEN_FOUR:
            return Color.green
        case .GREEN_FIVE:
            return Color.green
        case .GREEN_SIX:
            return Color.green
        case .GREEN_SEVEN:
            return Color.green
        case .GREEN_EIGHT:
            return Color.green
        case .GREEN_NINE:
            return Color.green
        case .YELLOW_ZERO:
            return Color.yellow
        case .YELLOW_ONE:
            return Color.yellow
        case .YELLOW_TWO:
            return Color.yellow
        case .YELLOW_THREE:
            return Color.yellow
        case .YELLOW_FOUR:
            return Color.yellow
        case .YELLOW_FIVE:
            return Color.yellow
        case .YELLOW_SIX:
            return Color.yellow
        case .YELLOW_SEVEN:
            return Color.yellow
        case .YELLOW_EIGHT:
            return Color.yellow
        case .YELLOW_NINE:
            return Color.yellow
        case .CHOOSE:
            return Color.black
        case .Y_CHOOSE:
            return Color.yellow
        case .G_CHOOSE:
            return Color.green
        case .R_CHOOSE:
            return Color.red
        case .B_CHOOSE:
            return Color.blue
        }
    }

    var number: Int {

        switch self {

        case .RED_ZERO, .BLUE_ZERO, .YELLOW_ZERO, .GREEN_ZERO:
            return 0
        case .RED_ONE, .BLUE_ONE, .YELLOW_ONE, .GREEN_ONE:
            return 1
        case .RED_TWO, .BLUE_TWO, .YELLOW_TWO, .GREEN_TWO:
            return 2
        case .RED_THREE, .BLUE_THREE, .YELLOW_THREE, .GREEN_THREE:
            return 3
        case .RED_FOUR, .BLUE_FOUR, .YELLOW_FOUR, .GREEN_FOUR:
            return 4
        case .RED_FIVE, .BLUE_FIVE, .YELLOW_FIVE, .GREEN_FIVE:
            return 5
        case .RED_SIX, .BLUE_SIX, .YELLOW_SIX, .GREEN_SIX:
            return 6
        case .RED_SEVEN, .BLUE_SEVEN, .YELLOW_SEVEN, .GREEN_SEVEN:
            return 7
        case .RED_EIGHT, .BLUE_EIGHT, .YELLOW_EIGHT, .GREEN_EIGHT:
            return 8
        case .RED_NINE, .BLUE_NINE, .YELLOW_NINE, .GREEN_NINE:
            return 9
        case .CHOOSE, .Y_CHOOSE, .G_CHOOSE, .R_CHOOSE, .B_CHOOSE:
            return -1


        }

    }
}

enum ActivePlayer: String {

    case playerOne = "Spieler 1"
    case playerTwo = "Spieler 2"

    func otherPlayer() -> ActivePlayer {
        switch self {
        case .playerOne:
            return .playerTwo
        case .playerTwo:
            return .playerOne
        }
    }

}

