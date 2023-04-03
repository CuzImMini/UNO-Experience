//
//  GameEngine.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//
//Benjamin wenn du das liest, ruf mich mal an

import Foundation
import MultipeerConnectivity
import os

class GameEngine: ObservableObject {

    //Variable für Zugriff auf den Session-Vermittler
    private var sessionHandler: MP_Session

    //Spielstatus
    @Published var gameState: GameStates = .noGame
    //Logger für Konsole
    let log = Logger()
    let encoder = JSONEncoder()


    //Initializer
    init(sessionHandler: MP_Session) {
        self.sessionHandler = sessionHandler
    }


    //Der gesamte Datenverkehr läuft über diese Funktion
    func trafficHandler(data: Data) {
        //Logging
        log.info("Datenpaket: \(data) empfangen.")
        print(String(data: data, encoding: .isoLatin1)!)

        //Enkodierung zu String und Auswahl Vorgang
        switch String(data: data, encoding: .isoLatin1) {

        case GameTraffic.stopGame.rawValue:
            cancelGame()
        case GameTraffic.win.rawValue:
            looseHandler()
        case String("Draw"):
            drawHandler()
                //Wenn eine Spielaktion empfangen wird
        case .some(_):
            gameActionHandler(data: data)

                //Wenn Paket nicht identifiziert werden kann
        case .none:
            log.info("Nicht identifizierbares Datenpacket empfangen")
        }


    }

    //Verarbeitung der Spielzüge
    func gameActionHandler(data: Data) {

        switch String(data: data, encoding: .isoLatin1) {

        case Cards.RED_ZERO.rawValue:
            self.changeCard(card: Cards.RED_ZERO)

        case Cards.RED_ONE.rawValue:
            self.changeCard(card: Cards.RED_ONE)

        case Cards.RED_TWO.rawValue:
            self.changeCard(card: Cards.RED_TWO)

        case Cards.RED_THREE.rawValue:
            self.changeCard(card: Cards.RED_THREE)

        case Cards.RED_FOUR.rawValue:
            self.changeCard(card: Cards.RED_FOUR)

        case Cards.RED_FIVE.rawValue:
            self.changeCard(card: Cards.RED_FIVE)

        case Cards.RED_SIX.rawValue:
            self.changeCard(card: Cards.RED_SIX)

        case Cards.RED_SEVEN.rawValue:
            self.changeCard(card: Cards.RED_SEVEN)

        case Cards.RED_EIGHT.rawValue:
            self.changeCard(card: Cards.RED_EIGHT)

        case Cards.RED_NINE.rawValue:
            self.changeCard(card: Cards.RED_NINE)

        case Cards.BLUE_ZERO.rawValue:
            self.changeCard(card: Cards.BLUE_ZERO)

        case Cards.BLUE_ONE.rawValue:
            self.changeCard(card: Cards.BLUE_ONE)

        case Cards.BLUE_TWO.rawValue:
            self.changeCard(card: Cards.BLUE_TWO)

        case Cards.BLUE_THREE.rawValue:
            self.changeCard(card: Cards.BLUE_THREE)

        case Cards.BLUE_FOUR.rawValue:
            self.changeCard(card: Cards.BLUE_FOUR)

        case Cards.BLUE_FIVE.rawValue:
            self.changeCard(card: Cards.BLUE_FIVE)

        case Cards.BLUE_SIX.rawValue:
            self.changeCard(card: Cards.BLUE_SIX)

        case Cards.BLUE_SEVEN.rawValue:
            self.changeCard(card: Cards.BLUE_SEVEN)

        case Cards.BLUE_EIGHT.rawValue:
            self.changeCard(card: Cards.BLUE_EIGHT)

        case Cards.BLUE_NINE.rawValue:
            self.changeCard(card: Cards.BLUE_NINE)

        case Cards.GREEN_ZERO.rawValue:
            self.changeCard(card: Cards.GREEN_ZERO)

        case Cards.GREEN_ONE.rawValue:
            self.changeCard(card: Cards.GREEN_ONE)

        case Cards.GREEN_TWO.rawValue:
            self.changeCard(card: Cards.GREEN_TWO)

        case Cards.GREEN_THREE.rawValue:
            self.changeCard(card: Cards.GREEN_THREE)

        case Cards.GREEN_FOUR.rawValue:
            self.changeCard(card: Cards.GREEN_FOUR)

        case Cards.GREEN_FIVE.rawValue:
            self.changeCard(card: Cards.GREEN_FIVE)

        case Cards.GREEN_SIX.rawValue:
            self.changeCard(card: Cards.GREEN_SIX)

        case Cards.GREEN_SEVEN.rawValue:
            self.changeCard(card: Cards.GREEN_SEVEN)

        case Cards.GREEN_EIGHT.rawValue:
            self.changeCard(card: Cards.GREEN_EIGHT)

        case Cards.GREEN_NINE.rawValue:
            self.changeCard(card: Cards.GREEN_NINE)

        case Cards.YELLOW_ZERO.rawValue:
            self.changeCard(card: Cards.YELLOW_ZERO)

        case Cards.YELLOW_ONE.rawValue:
            self.changeCard(card: Cards.YELLOW_ONE)

        case Cards.YELLOW_TWO.rawValue:
            self.changeCard(card: Cards.YELLOW_TWO)

        case Cards.YELLOW_THREE.rawValue:
            self.changeCard(card: Cards.YELLOW_THREE)

        case Cards.YELLOW_FOUR.rawValue:
            self.changeCard(card: Cards.YELLOW_FOUR)

        case Cards.YELLOW_FIVE.rawValue:
            self.changeCard(card: Cards.YELLOW_FIVE)

        case Cards.YELLOW_SIX.rawValue:
            self.changeCard(card: Cards.YELLOW_SIX)

        case Cards.YELLOW_SEVEN.rawValue:
            self.changeCard(card: Cards.YELLOW_SEVEN)

        case Cards.YELLOW_EIGHT.rawValue:
            self.changeCard(card: Cards.YELLOW_EIGHT)

        case Cards.YELLOW_NINE.rawValue:
            self.changeCard(card: Cards.YELLOW_NINE)

        case Cards.R_CHOOSE.rawValue:
            self.changeCard(card: Cards.R_CHOOSE)

        case Cards.G_CHOOSE.rawValue:
            self.changeCard(card: Cards.G_CHOOSE)

        case Cards.Y_CHOOSE.rawValue:
            self.changeCard(card: Cards.Y_CHOOSE)

        case Cards.B_CHOOSE.rawValue:
            self.changeCard(card: Cards.B_CHOOSE)

        case Cards.YFORCESKIP.rawValue:
            self.changeCard(card: Cards.YFORCESKIP)

        case Cards.GFORCESKIP.rawValue:
            self.changeCard(card: Cards.GFORCESKIP)

        case Cards.BFORCESKIP.rawValue:
            self.changeCard(card: Cards.BFORCESKIP)

        case Cards.RFORCESKIP.rawValue:
            self.changeCard(card: Cards.RFORCESKIP)

        case Cards.YELLOWDRAWTWO.rawValue:
            self.changeCard(card: Cards.YELLOWDRAWTWO)

        case Cards.GREENDRAWTWO.rawValue:
            self.changeCard(card: Cards.GREENDRAWTWO)

        case Cards.REDDRAWTWO.rawValue:
            self.changeCard(card: Cards.REDDRAWTWO)

        case Cards.BLUEDRAWTWO.rawValue:
            self.changeCard(card: Cards.BLUEDRAWTWO)


        case .none:
            log.error("Nope")
        case .some(_):
            log.error("Nope")

        }
    }


    func startGame() {
        if sessionHandler.activeCard.number < 0 {
            sessionHandler.activeCard = Card.getRandom(id: 0).type
            self.startGame()
            return
        }

        sessionHandler.stopConnectionMode()

        DispatchQueue.main.async {
            self.sessionHandler.viewState = .inGame
            self.sessionHandler.cardProbabilityDeck = Card.getRealDeck()
        }
        sessionHandler.sendTraffic(data: GameTraffic.startGame.rawValue.data(using: .isoLatin1)!)


        sessionHandler.sendTraffic(data: sessionHandler.activeCard.rawValue.data(using: .isoLatin1)!)


        //Generiere zwei Kartendecks
        let cardDeck1: [Card] = Card.getRandom(amount: 8, sessionHandler: sessionHandler)
        let cardDeck2: [Card] = Card.getRandom(amount: 8, sessionHandler: sessionHandler)

        var encodedArray1: Data
        var encodedArray2: Data

        //Verschlüssele Decks
        do {
            encodedArray1 = try encoder.encode(cardDeck1)
            encodedArray2 = try encoder.encode(cardDeck2)

            //Sende Decks an beide Clients
            sessionHandler.sendTraffic(data: encodedArray1, peer: sessionHandler.connectedPeers[0])
            sessionHandler.sendTraffic(data: encodedArray2, peer: sessionHandler.connectedPeers[1])
        } catch {
        }


    }

    func restart() {
        startGame()
        DispatchQueue.main.async {
            self.sessionHandler.cardStack = [Card(id: 0, type: self.sessionHandler.activeCard)]
        }
    }

    func drawHandler() {

        do {
            let drawnCard = Card.getRandom(id: 0, sessionHandler: sessionHandler)
            var encodedCard: Data
            try encodedCard = encoder.encode(drawnCard)

            sessionHandler.sendTraffic(data: encodedCard)
        } catch {
            log.error("Fehler beim Codieren! Host")
        }

    }


    //TO-DO Spielabbruch bei Verbindungsverlust
    func cancelGame() {
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .mainMenu
            self.sessionHandler.cardStack = []
        }
        sessionHandler.sendTraffic(data: GameTraffic.stopGame.rawValue.data(using: .isoLatin1)!)
    }


    func changeCard(card: Cards) {
        DispatchQueue.main.async {
            self.sessionHandler.activeCard = card
            self.sessionHandler.cardStack.append(Card(id: self.sessionHandler.cardStack.count, type: card, rotationRadian: Double.random(in: 0...6.2)))
        }

    }

    func winHandler() {
        sessionHandler.sendTraffic(data: GameTraffic.win.rawValue.data(using: .isoLatin1)!)
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .win
        }

    }

    func looseHandler() {
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .loose
        }
    }


}
