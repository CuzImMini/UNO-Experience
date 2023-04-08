//
//  GameEnums.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//

import Foundation
import SwiftUI

enum ViewStates: String {

    case hostMainMenu = "hostmainmenu"
    case clientMainMenu = "clientmainmenu"
    case clientInGame = "clientingame"
    case hostInGame = "hostingame"
    case hostGameEnd = "hostgameend"
    case loose = "loose"
    case win = "win"

}

enum TargetNames: String {
    
    case allDevices = "atAll"
    case allPlayers = "atPlayers"
    case host = "HOST"


}

enum GameActions: String {

    case startGame = "gamestart"
    case stopGame = "gamestop"
    case win = "win"
    case announceActivePlayer = "announceActivePlayer"

}

enum CardActions: String {

    case announceCard = "announceCard"
    case playCard = "playCard"
    case announceDeck = "announceDeck"
    case requestCard = "requestDraw"
    case drawnCardFromHost = "drawnCardFromHost"
    case requestSkip = "requestSkip"

}

enum TrafficTypes: String {
    
    case gameActionIdentifier = "gametraffic"
    case cardActionIdentifier = "cardAction"
}

enum Cards: String, CaseIterable, Codable {

    case RED_ZERO = "Red0"
    case RED_ONE = "Red1"
    case RED_TWO = "Red2"
    case RED_THREE = "Red3"
    case RED_FOUR = "Red4"
    case RED_FIVE = "Red5"
    case RED_SIX = "Red6"
    case RED_SEVEN = "Red7"
    case RED_EIGHT = "Red8"
    case RED_NINE = "Red9"
    case BLUE_ZERO = "Blue0"
    case BLUE_ONE = "Blue1"
    case BLUE_TWO = "Blue2"
    case BLUE_THREE = "Blue3"
    case BLUE_FOUR = "Blue4"
    case BLUE_FIVE = "Blue5"
    case BLUE_SIX = "Blue6"
    case BLUE_SEVEN = "Blue7"
    case BLUE_EIGHT = "Blue8"
    case BLUE_NINE = "Blue9"
    case GREEN_ZERO = "Green0"
    case GREEN_ONE = "Green1"
    case GREEN_TWO = "Green2"
    case GREEN_THREE = "Green3"
    case GREEN_FOUR = "Green4"
    case GREEN_FIVE = "Green5"
    case GREEN_SIX = "Green6"
    case GREEN_SEVEN = "Green7"
    case GREEN_EIGHT = "Green8"
    case GREEN_NINE = "Green9"
    case YELLOW_ZERO = "Yellow0"
    case YELLOW_ONE = "Yellow1"
    case YELLOW_TWO = "Yellow2"
    case YELLOW_THREE = "Yellow3"
    case YELLOW_FOUR = "Yellow4"
    case YELLOW_FIVE = "Yellow5"
    case YELLOW_SIX = "Yellow6"
    case YELLOW_SEVEN = "Yellow7"
    case YELLOW_EIGHT = "Yellow8"
    case YELLOW_NINE = "Yellow9"
    case CHOOSE = "CHOOSE"
    case Y_CHOOSE = "YCHOOSE"
    case G_CHOOSE = "GCHOOSE"
    case R_CHOOSE = "RCHOOSE"
    case B_CHOOSE = "BCHOOSE"
    case YFORCESKIP = "YFORCESKIP"
    case GFORCESKIP = "GFORCESKIP"
    case RFORCESKIP = "RFORCESKIP"
    case BFORCESKIP = "BFORCESKIP"
    case YELLOWDRAWTWO = "YELLOWDRAWTWO"
    case GREENDRAWTWO = "GREENDRAWTWO"
    case REDDRAWTWO = "REDDRAWTWO"
    case BLUEDRAWTWO = "BLUEDRAWTWO"
    
    
    
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
        case .YFORCESKIP: return "Gelb aussetzen"
        case .GFORCESKIP: return "Grün aussetzen"
        case .RFORCESKIP: return "Rot aussetzen"
        case .BFORCESKIP: return "Blau aussetzen"
        case .YELLOWDRAWTWO: return "Gelb zwei ziehen"
        case .GREENDRAWTWO: return "Grün zwei ziehen"
        case .REDDRAWTWO: return "Rot zwei ziehen"
        case .BLUEDRAWTWO: return "Blau zwei ziehen"


        }
    }

    var color: Color {
        switch self {
        case .RED_ZERO:
            return Color.red
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
        case .YFORCESKIP:
            return Color.yellow
        case .GFORCESKIP:
            return Color.green
        case .RFORCESKIP:
            return Color.red
        case .BFORCESKIP:
            return Color.blue
        case .YELLOWDRAWTWO:
            return Color.yellow
        case .GREENDRAWTWO:
            return Color.green
        case .REDDRAWTWO:
            return Color.red
        case .BLUEDRAWTWO:
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
        case .YFORCESKIP, .GFORCESKIP, .RFORCESKIP, .BFORCESKIP:
            return -2
        case .YELLOWDRAWTWO, .BLUEDRAWTWO, .REDDRAWTWO, .GREENDRAWTWO:
            return -3

        }

    }
}
/*
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
*/

