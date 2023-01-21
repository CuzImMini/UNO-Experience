//
//  GameEngine.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//


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
    
    //TO-DO Spielabbruch bei Verbindungsverlust
    func cancelGame(message: String) {
        
    }
    
    //Der gesamte Datenverkehr läuft über diese Funktion
    func trafficHandler(data: Data) {
        //Logging
        log.info("Datenpaket: \(data) empfangen.")
        
        //Enkodierung zu String und Auswahl Vorgang
        switch String(data: data, encoding: .isoLatin1) {
            
            //wenn View-Wechsel versendet wurde
        case ViewStates.inGame.rawValue:
            DispatchQueue.main.async {
                self.sessionHandler.viewState = .inGame
            }
        case ViewStates.mainMenu.rawValue:
            DispatchQueue.main.async {
                self.sessionHandler.viewState = .mainMenu
            }
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
        self.sessionHandler.sendTraffic(data: viewState.rawValue.data(using: .isoLatin1)!)
    }

    
    
    
}
