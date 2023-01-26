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
        log.info("Datenpaket: \(data) empfangen.")
        print(String(data: data, encoding: .isoLatin1)!)

        //Enkodierung zu String und Auswahl Vorgang
        switch String(data: data, encoding: .isoLatin1) {

        case GameTraffic.startGame.rawValue:
            self.startGame()

        case GameTraffic.stopGame.rawValue:
            self.cancelGame()
        case GameTraffic.win.rawValue:
            self.looseHandler()
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
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_ZERO)
            }
        case Cards.RED_ONE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_ONE)
            }
        case Cards.RED_TWO.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_TWO)
            }
        case Cards.RED_THREE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_THREE)
            }
        case Cards.RED_FOUR.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_FOUR)
            }
        case Cards.RED_FIVE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_FIVE)
            }
        case Cards.RED_SIX.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_SIX)
            }
        case Cards.RED_SEVEN.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_SEVEN)
            }
        case Cards.RED_EIGHT.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_EIGHT)
            }
        case Cards.RED_NINE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.RED_NINE)
            }
        case Cards.BLUE_ZERO.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_ZERO)
            }
        case Cards.BLUE_ONE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_ONE)
            }
        case Cards.BLUE_TWO.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_TWO)
            }
        case Cards.BLUE_THREE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_THREE)
            }
        case Cards.BLUE_FOUR.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_FOUR)
            }
        case Cards.BLUE_FIVE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_FIVE)
            }
        case Cards.BLUE_SIX.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_SIX)
            }
        case Cards.BLUE_SEVEN.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_SEVEN)
            }
        case Cards.BLUE_EIGHT.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_EIGHT)
            }
        case Cards.BLUE_NINE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.BLUE_NINE)
            }
        case Cards.YELLOW_ZERO.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_ZERO)
            }
        case Cards.YELLOW_ONE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_ONE)
            }
        case Cards.YELLOW_TWO.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_TWO)
            }
        case Cards.YELLOW_THREE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_THREE)
            }
        case Cards.YELLOW_FOUR.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_FOUR)
            }
        case Cards.YELLOW_FIVE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_FIVE)
            }
        case Cards.YELLOW_SIX.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_SIX)
            }
        case Cards.YELLOW_SEVEN.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_SEVEN)
            }
        case Cards.YELLOW_EIGHT.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_EIGHT)
            }
        case Cards.YELLOW_NINE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.YELLOW_NINE)
            }
        case Cards.GREEN_ZERO.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_ZERO)
            }
        case Cards.GREEN_ONE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_ONE)
            }
        case Cards.GREEN_TWO.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_TWO)
            }
        case Cards.GREEN_THREE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_THREE)
            }
        case Cards.GREEN_FOUR.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_FOUR)
            }
        case Cards.GREEN_FIVE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_FIVE)
            }
        case Cards.GREEN_SIX.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_SIX)
            }
        case Cards.GREEN_SEVEN.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_SEVEN)
            }
        case Cards.GREEN_EIGHT.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_EIGHT)
            }
        case Cards.GREEN_NINE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.GREEN_NINE)
            }
        case Cards.CHOOSE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.CHOOSE)
            }
        case Cards.Y_CHOOSE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.Y_CHOOSE)
            }
        case Cards.G_CHOOSE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.G_CHOOSE)
            }
        case Cards.B_CHOOSE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.B_CHOOSE)
            }
        case Cards.R_CHOOSE.rawValue:
            DispatchQueue.main.async {
                self.changeCard(card: Cards.R_CHOOSE)
            }


        case .none:
            log.error("Nope")
        case .some(_):
            log.error("Nope")

        }
    }

    //Wechseln des Gamestatus
    //TO-DO
    //- no game
    //- running
    //- ended mit siegeranzeige und resetknopf

    func changeGameState(viewState: ViewStates, gameState: GameStates) {
        self.sessionHandler.sendTraffic(data: gameState.rawValue.data(using: .isoLatin1)!)

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
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .inGame
        }
        self.sessionHandler.sendTraffic(data: GameTraffic.startGame.rawValue.data(using: .isoLatin1)!)
    }

    //TO-DO Spielabbruch bei Verbindungsverlust
    func cancelGame() {
        DispatchQueue.main.async {
            self.sessionHandler.viewState = .mainMenu
        }
        self.sessionHandler.sendTraffic(data: GameTraffic.stopGame.rawValue.data(using: .isoLatin1)!)
    }

    func changeCard(card: Cards) {

        DispatchQueue.main.async {
            self.sessionHandler.activeCard = card
        }


        if self.sessionHandler.activePlayer == .playerOne {
            self.sessionHandler.activePlayer = .playerTwo
        }
        if self.sessionHandler.activePlayer == .playerTwo {
            self.sessionHandler.activePlayer = .playerOne
        }
        self.sessionHandler.hasPlayed = false

    }

    func winHandler() {
        self.sessionHandler.sendTraffic(data: GameTraffic.win.rawValue.data(using: .isoLatin1)!)
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
