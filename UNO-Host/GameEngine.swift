import Foundation
import os
import SwiftUI

struct GameEngine {
    
    //Logger für Konsole
    let log = Logger()
    
    //Variable für Zugriff auf den Session-Vermittler
    private var sessionHandler: MP_Session
    
    //Kodierer für Karten und Decks
    let encoder = JSONEncoder()
    var cardDeckSize: Int = 8
    
    //Spielvariablen
    var activeCard: Cards = .BLUE_ONE
    var cardStack: [Card] = []
    var cardProbabilityDeck: [Cards]
    
    //aktuelle Ansicht auf den Geräten...
    var viewState: ViewStates = .mainMenu
    var winnerName: String = ""
    
    //Initializer
    init(sessionHandler: MP_Session) {
        self.sessionHandler = sessionHandler
        self.cardProbabilityDeck = Card.getRealDeck()
        
    }
    
    
    mutating func startGame(deckSize: Int) {
        //Suche erste Karte
        activeCard = Card.getRandom(id: 0, sessionHandler: sessionHandler).type
        //Prüfe ob erste Karte geeignet ist:
        if activeCard.number < 0 {
            cardProbabilityDeck = Card.getRealDeck()
            activeCard = Card.getRandom(id: 0, sessionHandler: sessionHandler).type
            self.startGame(deckSize: deckSize)
            return
        }
        //Stelle Deckgröße ein
        self.cardDeckSize = deckSize
        //Füge erste Karte zum Stapel hinzu
        cardStack = [Card(id: 0, type: activeCard)]
        
        //Stoppe den Verbindungsmodus
        sessionHandler.stopConnectionMode()
        
        //Sende aktive Karte an beide Geräte
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.announceCard.rawValue, packet2: activeCard.rawValue)
        
        //Generiere Deck für jeden Spieler und sende es zu
            for peer in sessionHandler.connectedPeers {
                do {
                    let encodedDeck = try encoder.encode(Card.getRandom(amount: cardDeckSize, sessionHandler: sessionHandler))
                    sessionHandler.sendTraffic(recipient: peer.displayName, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.announceDeck.rawValue, packet2: String(data: encodedDeck, encoding: .isoLatin1)!)
                }
                catch {self.log.error("Fehler beim Kodieren der Decks")}
            }
        
        //Ändere den Ansichtsstatus bei allen Geräten
        self.viewState = .inGame
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.startGame.rawValue, packet2: "")
        
    }
    
    
    func drawHandler(recipient: String, amount: Int) {
        
        for _ in 1...amount {
            do {
                let encodedCard = try encoder.encode(Card.getRandom(id: 0, sessionHandler: sessionHandler))
                sessionHandler.sendTraffic(recipient: recipient, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.drawnCardFromHost.rawValue, packet2: String(data: encodedCard, encoding: .isoLatin1)!)
            } catch {
                log.error("Fehler beim Codieren! Host")
            }
            Thread.sleep(until: .now + 0.5)
        }
        

        
    }
    
    
    mutating func cancelGame() {
        self.viewState = .mainMenu
                
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.stopGame.rawValue, packet2: "")
    }
    
 
    mutating func changeCard(cardRawValue: String) {
        
        var cardToChangeTo: Cards = .BLUE_ONE
        
        for card in Cards.allCases {
            if cardRawValue == card.rawValue {
                cardToChangeTo = card
            }
        }

            activeCard = cardToChangeTo
            self.cardStack.append(Card(id: self.cardStack.count, type: cardToChangeTo, rotationDegree: Int.random(in: 0...360)))
            
        
    }
    
    
    
    mutating func endGameHandler(winnerName: String) {
        
        self.winnerName = winnerName
        self.viewState = .win
    }
    
    
}

