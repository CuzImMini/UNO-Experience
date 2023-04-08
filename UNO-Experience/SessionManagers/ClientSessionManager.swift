//
//  MP_Session.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//

import MultipeerConnectivity
import Foundation
import os

class ClientSessionManager: NSObject, ObservableObject {
    //Logger für Konsole
    private let log = Logger()
    
    //Bonjour-Erkennungszeichen
    private let serviceType = "unoexperience"
    //Peer-ID für ausführendes Gerät
    var myPeerId = MCPeerID(displayName: UIDevice.current.name)
    //Advertiser & Browser zum suchen und finden anderer Geräte
    private var serviceAdvertiser: MCNearbyServiceAdvertiser?
    private var serviceBrowser: MCNearbyServiceBrowser?
    //Session, über die Daten empfangen und ausgelesen werden können
    private var session: MCSession?
    
    //Liste mit allen verbundenen Geräten
    @Published var connectedPeers: [MCPeerID] = []
    @Published var isOnline: Bool = false
    
    //Variable um auf GameEngine zuzugreifen
    @Published var gameHandler: ClientGameEngine!

    //Decoder
    let decoder = JSONDecoder()
    
    
    //initializer
    override init() {
        //Initialisierung Vererbungen
        super.init()
        
        log.debug("ClientSessionManager initialisiert")
        gameHandler = ClientGameEngine(sessionHandler: self)
    }
    
    //Deaktiviert Bonjour-Dienste wenn App geschlossen wird
    deinit {
        log.debug("ClientSessionManager deinitialisiert")

        serviceBrowser?.stopBrowsingForPeers()
        serviceAdvertiser?.stopAdvertisingPeer()
        
        isOnline = false
    }
    
    //Jeder gesendete Traffic läuft hierüber
    func sendTraffic(recipient: String, prefix: String, packet1: String, packet2: String) {
        
        log.debug("Sende Daten: \(recipient + "#" + prefix + "#" + packet1 + "#" + packet2)")
        
        let data = String(recipient + "#" + prefix + "#" + packet1 + "#" + packet2).data(using: .isoLatin1)!
        
        var recipientPeerIDs = session?.connectedPeers ?? []
        
        if recipient == TargetNames.host.rawValue {
            recipientPeerIDs = [(session?.connectedPeers.first(where: {$0.displayName == TargetNames.host.rawValue}))!]
        }
        else if recipient == TargetNames.allPlayers.rawValue {
            recipientPeerIDs.remove(at: recipientPeerIDs.firstIndex(where: {$0.displayName == TargetNames.host.rawValue})!)
        }
        
        do {
            try session?.send(data, toPeers: recipientPeerIDs, with: .reliable)
        } catch {
            log.error("Error beim senden: \(String(describing: error))")
        }
    }
    
    //Starten der Bonjour-Dienste
    func goOnline(username: String) {

        myPeerId = MCPeerID(displayName: username)
        
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        
        session?.delegate = self
        serviceAdvertiser?.delegate = self
        serviceBrowser?.delegate = self
        
        
        serviceBrowser?.startBrowsingForPeers()
        serviceAdvertiser?.startAdvertisingPeer()
        
        isOnline = true
        
        log.debug("Gehe Online")
    }
    
    func goOffline() {
        log.debug("Gehe Offline")
        
        serviceAdvertiser?.stopAdvertisingPeer()
        serviceBrowser?.stopBrowsingForPeers()
        
        session?.disconnect()
        
        isOnline = false
    }
    
    func stopConnectionMode() {
        log.debug("Stoppe den Verbindungsmodus für neue Geräte/Sessions")
        serviceBrowser?.stopBrowsingForPeers()
        serviceAdvertiser?.stopAdvertisingPeer()
        
        isOnline = false
    }
    
    //Der gesamte Datenverkehr läuft über diese Funktion
    func trafficHandler(data: Data, peerID: MCPeerID) {
        DispatchQueue.main.async {
            //Logging
            self.log.debug("Datenpaket: \(String(data: data, encoding: .isoLatin1)!) empfangen.")
            
            //Aufbau beim Aussenden: Neues GameTraffic System mit Prefix und Daten
            //[0] steht für den Namen des Empfängers (all bei an alle)
            //[1] steht für das Prefix
            //[2] steht für das erste gesendete Datenpaket
            //[3] steht für das zweite gesendete Datenpaket etc.
            
            //Aufbau als Array:
            //[0] Name des Aussendenden
            //[1] steht für den Namen des Empfängers (all bei an alle)
            //[2] steht für das Prefix
            //[3] steht für das erste gesendete Datenpaket
            //[4] steht für das zweite gesendete Datenpaket etc.
            
            //Enkodierung der einzelnen Packet-Teile
            var decodedDataArray: [String] = [peerID.displayName]
            decodedDataArray += String(data: data, encoding: .isoLatin1)!.components(separatedBy: "#")
            
            if (decodedDataArray[1] != self.myPeerId.displayName) && (decodedDataArray[1] != TargetNames.allDevices.rawValue) && (decodedDataArray[1] != TargetNames.allPlayers.rawValue) {return}
            
            //Prefix zuordnen
            switch decodedDataArray[2] {
            
            //"wenn GameTraffic"
            case TrafficTypes.gameActionIdentifier.rawValue:
                self.log.debug("GameAction Paket empfangen")
                switch decodedDataArray[3] {
                    
                case GameActions.win.rawValue:
                    self.log.debug("Win-empfangen. Starte Loose-Handler")
                    self.gameHandler.looseHandler(opponentName: decodedDataArray[0])
                case GameActions.stopGame.rawValue:
                    self.log.debug("Stopp-empfangen. Breche Spiel ab")
                    self.gameHandler.cancelGame(selfInitiated: false)
                case GameActions.startGame.rawValue:
                    self.log.debug("Start-empfangen. Starte Spiel")
                    self.gameHandler.startGame()
                case GameActions.announceActivePlayer.rawValue:
                    self.log.debug("Spieler Ankündigung. Localhost ist am  Zug")
                    self.gameHandler.playerAnnouncement()
                default:
                    self.log.error("Fehler bei der Übertragung eines GameAction Packetes")
                }
                
            case TrafficTypes.cardActionIdentifier.rawValue:
                
                self.log.debug("CardAction Paket empfangen")
                switch decodedDataArray[3] {
                    
                case CardActions.announceCard.rawValue:
                    self.log.debug("Neue Karte angekündigt")
                    self.gameHandler.changeCard(cardRawValue: decodedDataArray[4])
                case CardActions.playCard.rawValue:
                    self.log.debug("Neue Karte ausgespielt")
                    self.gameHandler.changeCard(cardRawValue: decodedDataArray[4])
                case CardActions.announceDeck.rawValue:
                    self.log.debug("Kartendeck vom Host erhalten")
                    self.gameHandler.cardDeck = self.decodeCards(type: [Card].self, cardData: decodedDataArray[4]) as! [Card]
                    self.gameHandler.lastDeckCount = self.gameHandler.cardDeck.count
                case CardActions.drawnCardFromHost.rawValue:
                    self.log.debug("Karte vom Host erhalten")
                    let card: Card = self.decodeCards(type: Card.self, cardData: decodedDataArray[4]) as! Card
                    self.gameHandler.cardDeck.append(Card(id: self.gameHandler.cardDeck.last!.id + 1, type: card.type))
                    
                default:
                    self.log.error("Fehler bei der Übertragung eines CardAction Packetes")

                }

            default:
                self.log.error("Fehler bei Packetübertragung")
            }

    
            
        }
        
        
    }
    
    func decodeCards(type: any Codable.Type, cardData: String) -> any Codable {
        log.debug("Dekodiere Karte/n")
        var decodedCards: (any Codable)?
        do {
            log.info("Karte/n erfolgreich dekodiert")
            decodedCards = try self.decoder.decode(type.self, from: cardData.data(using: .isoLatin1)!)
        }
        catch {self.log.error("Fehler bei Dekodierung von Karten oder Kartendecks")}
        
        return decodedCards!

    }
    
}

//automatisches Annehmen von Einladungen und Beenden der Suche für weitere Clients
extension ClientSessionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("Einladung erhalten von \(peerID)")
        invitationHandler(true, session)
        serviceAdvertiser?.stopAdvertisingPeer()
        serviceBrowser?.stopBrowsingForPeers()
    }
    
}

extension ClientSessionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
        
    }
    
}

//Ausführung wenn sich der Status eines Gerätes im Netz geändert hat
extension ClientSessionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        DispatchQueue.main.async {
            self.connectedPeers = session.connectedPeers
        }
        
    }
    
    //Ausführung wenn Daten empfangen werden -> Weiterleitung an trafficHandler der GameEngine
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        self.trafficHandler(data: data, peerID: peerID)
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
}

