import Foundation
import os
import SwiftUI

struct HostGameEngine {
    
    //Logger für Konsole
    let log = Logger()
    
    //Variable für Zugriff auf den Session-Vermittler
    private var sessionHandler: HostSessionManager
    
    //Kodierer für Karten und Decks
    let encoder = JSONEncoder()
    var cardDeckSize: Int = 8
    
    //Spielvariablen
    var activeCard: Cards = .BLUE_ONE
    var cardStack: [Card] = []
    var cardProbabilityDeck: [Cards]
    
    var activeViewArray: [ViewStates] = []
    
    //aktuelle Ansicht auf den Geräten...
    var winnerName: String = ""
    var players: [String] = []
    var activePlayerIndex: Int = 0
    
    //Initializer
    init(sessionHandler: HostSessionManager) {
        log.debug("HostGameEngine initialisiert")

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
        log.debug("Starte das Spiel")
        //Stelle Deckgröße ein
        self.cardDeckSize = deckSize
        //Füge erste Karte zum Stapel hinzu
        cardStack = [Card(id: 0, type: activeCard)]
        
        //Stoppe den Verbindungsmodus
        sessionHandler.stopConnectionMode()
        
        //Sende aktive Karte an Geräte
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.announceCard.rawValue, packet2: activeCard.rawValue)
        
        //Generiere Deck für jeden Spieler und sende es zu
            for peer in sessionHandler.connectedPeers {
                do {
                    let encodedDeck = try encoder.encode(Card.getRandom(amount: cardDeckSize, sessionHandler: sessionHandler))
                    sessionHandler.sendTraffic(recipient: peer.displayName, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.announceDeck.rawValue, packet2: String(data: encodedDeck, encoding: .isoLatin1)!)
                }
                catch {self.log.error("Fehler beim Kodieren der Decks")}
            }
        
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.startGame.rawValue, packet2: "")
        
        //Ändere den Ansichtsstatus
        self.activeViewArray.append(.hostInGame)
        let arrayToLog = activeViewArray
        log.debug("activeViewArray verändert. Nun: \(arrayToLog)")
        
        //Ändere den Ansichtsstatus bei allen Geräten
        playerAnnouncementHandler()
        
        let randomPlayer = players.randomElement()!
        activePlayerIndex = players.firstIndex(where: {$0 == randomPlayer})!
        sessionHandler.sendTraffic(recipient: randomPlayer, prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.announceActivePlayer.rawValue, packet2: "")

    }
    
    mutating func restartGame() {
        //Suche erste Karte
        activeCard = Card.getRandom(id: 0, sessionHandler: sessionHandler).type
        //Prüfe ob erste Karte geeignet ist:
        if activeCard.number < 0 {
            cardProbabilityDeck = Card.getRealDeck()
            activeCard = Card.getRandom(id: 0, sessionHandler: sessionHandler).type
            self.restartGame()
            return
        }
        log.debug("Starte das Spiel neu!")
        
        cardStack = [Card(id: 0, type: activeCard)]
        
        //Sende aktive Karte an Geräte
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.announceCard.rawValue, packet2: activeCard.rawValue)


        //Generiere Deck für jeden Spieler und sende es zu
            for player in players {
                do {
                    let encodedDeck = try encoder.encode(Card.getRandom(amount: cardDeckSize, sessionHandler: sessionHandler))
                    sessionHandler.sendTraffic(recipient: player, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.announceDeck.rawValue, packet2: String(data: encodedDeck, encoding: .isoLatin1)!)
                }
                catch {self.log.error("Fehler beim Kodieren der Decks")}
            }
        
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.startGame.rawValue, packet2: "")
        
        //Ändere den Ansichtsstatus bei allen Geräten
        self.activeViewArray.append(.hostInGame)
        let arrayToLog = activeViewArray
        log.debug("activeViewArray verändert. Nun: \(arrayToLog)")

        let randomPlayer = players.randomElement()!
        activePlayerIndex = players.firstIndex(where: {$0 == randomPlayer})!
        sessionHandler.sendTraffic(recipient: randomPlayer, prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.announceActivePlayer.rawValue, packet2: "")
        
    }
    
    
    func drawHandler(recipient: String, amount: Int) {
        
        log.debug("Spieler \(recipient) hat eine Karte angefragt.")
        
        for _ in 1...amount {
            do {
                let encodedCard = try encoder.encode(Card.getRandom(id: 0, sessionHandler: sessionHandler))
                sessionHandler.sendTraffic(recipient: recipient, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.drawnCardFromHost.rawValue, packet2: String(data: encodedCard, encoding: .isoLatin1)!)
            } catch {
                log.error("Fehler beim Codieren!")
            }
            Thread.sleep(until: .now + 0.5)
        }
        

        
    }
    
    mutating func playerSequenceHandler() {
        log.debug("Ermittle nächsten Spieler an der Reihe:")
        let indexToLog = activePlayerIndex
        
        log.debug("aktiver Spielerindex auf: \(indexToLog)")
        activePlayerIndex = giveNextPlayerIndex()
        log.info("Wechsle zum nächsten Spieler...")
        
        sessionHandler.sendTraffic(recipient: players[activePlayerIndex], prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.announceActivePlayer.rawValue, packet2: "")
        
    }
    
    func giveNextPlayerIndex() -> Int {
        if activePlayerIndex < players.count - 1 {return (activePlayerIndex + 1)}
        else {return 0}
    }
    
    
    mutating func cancelGame(selfInitiated: Bool) {
        log.debug("Stoppe Spiel. Befehl erhalten: \(selfInitiated)")
        activeViewArray = [.hostMainMenu]
        let arrayToLog = activeViewArray
        log.debug("activeViewArray verändert. Nun: \(arrayToLog)")
        
        if selfInitiated {
            sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.gameActionIdentifier.rawValue, packet1: GameActions.stopGame.rawValue, packet2: "")
        }
        let sessionHandlerVar = self.sessionHandler
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {sessionHandlerVar.goOffline()}
    }
    
 
    mutating func changeCard(cardRawValue: String) {
        log.debug("Wechsle aktive Karte auf \(cardRawValue)")

        var cardToChangeTo: Cards = .BLUE_ONE
        
        for card in Cards.allCases {
            if cardRawValue == card.rawValue {
                cardToChangeTo = card
            }
        }

            activeCard = cardToChangeTo
            self.cardStack.append(Card(id: self.cardStack.count, type: cardToChangeTo, rotationDegree: Int.random(in: 0...360)))
        
        if cardToChangeTo.number == -3 {
            log.debug("Zwei Ziehen erkannt, gebe nächstem Spieler zwei Karten")
                drawHandler(recipient: players[giveNextPlayerIndex()], amount: 2)
            
        }
        
        if cardToChangeTo.number != -2 {
            log.debug("Karte gelegt. Ermittle nächsten Spieler")
            self.playerSequenceHandler()
        } else {log.debug("Aussetzen gelegt, ermittle keinen nächsten Spieler.")}

        
    }
    
    mutating func endGameHandler(winnerName: String) {
        log.debug("Das Spiel ist zuende. \(winnerName) gat gewonnen.")
        self.winnerName = winnerName
        self.activeViewArray.append(.hostGameEnd)
        
        let arrayToLog = activeViewArray
        log.debug("activeViewArray verändert. Nun: \(arrayToLog)")
    }
    
    mutating func playerAnnouncementHandler() {
        for player in sessionHandler.connectedPeers {
            self.players.append(player.displayName)
        }
        let arrayToLog = players
        log.debug("Erstelle Spielerliste: \(arrayToLog)")

    }
    
    
}

