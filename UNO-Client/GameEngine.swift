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

    //Initializer
    init(sessionHandler: MP_Session) {
        self.sessionHandler = sessionHandler
    }


    //Der gesamte Datenverkehr läuft über diese Funktion
    func trafficHandler(data: Data) {
        //Logging
        log.info("Datenpaket: \(String(data: data, encoding: .isoLatin1)!) empfangen.")

        //Enkodierung zu String und Auswahl Vorgang
        switch String(data: data, encoding: .isoLatin1) {

        case GameTraffic.startGame.rawValue:
            self.startGame()

        case GameTraffic.stopGame.rawValue:
            self.cancelGame()
        case GameTraffic.win.rawValue:
            self.looseHandler()
        case GameTraffic.skip.rawValue:
            self.skipHandler()
                //Wenn eine Spielaktion empfangen wird
        case .some(_):
            self.gameActionHandler(data: data)

                //Wenn Paket nicht identifiziert werden kann
        case .none:
            self.log.info("Nicht identifizierbares Datenpacket empfangen")
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
        case Cards.CHOOSE.rawValue:
            self.changeCard(card: Cards.CHOOSE)
        case Cards.Y_CHOOSE.rawValue:
            self.changeCard(card: Cards.Y_CHOOSE)
        case Cards.G_CHOOSE.rawValue:
            self.changeCard(card: Cards.G_CHOOSE)
        case Cards.B_CHOOSE.rawValue:
            self.changeCard(card: Cards.B_CHOOSE)
        case Cards.R_CHOOSE.rawValue:
            self.changeCard(card: Cards.R_CHOOSE)

        case .none:
            log.error("Keine Daten!")
        case .some(_):
            log.error("Irgendwelche Daten nicht zuordnebar!")

        }
    }


    //Wechseln der Anzeigemodi auf den Endgeräten
    func changeViewState(viewState: ViewStates) {
        self.sessionHandler.viewState = viewState
    }

    func startGame() {
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .inGame
        }
    }

    func startGameEverywhere() {
        log.info("Der Host hat das Spiel gestartet!")
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .inGame
        }
        self.sessionHandler.sendTraffic(data: GameTraffic.startGame.rawValue.data(using: .isoLatin1)!)
    }

    //TO-DO Spielabbruch bei Verbindungsverlust
    func cancelGame() {
        log.info("Das Spiel wurde abgebrochen!")
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .mainMenu
        }
    }

    func changeCard(card: Cards) {
        log.info("Die Karte wurde auf \(card.description) geändert!")

        DispatchQueue.main.async {
            self.sessionHandler.activeCard = card
            self.sessionHandler.hasPlayed = false

        }


    }

    func winHandler() {
        log.info("Gewonnen")
        self.sessionHandler.sendTraffic(data: GameTraffic.win.rawValue.data(using: .isoLatin1)!)
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .win
        }

    }

    func looseHandler() {
        log.info("Der Gegenspieler hat gewonnen.")
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .loose
        }
    }

    func skipHandler() {
        log.info("Gegenspieler hat ausgesetzt. Fahre mit Zug fort!")
        DispatchQueue.main.async {
            self.sessionHandler.hasPlayed = false

        }
    }


}
