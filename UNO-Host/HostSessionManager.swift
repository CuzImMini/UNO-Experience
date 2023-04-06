//
//  MP_Session.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//

import MultipeerConnectivity
import Foundation
import os
import SwiftUI

class MP_Session: NSObject, ObservableObject {
    
    //Bonjour-Erkennungs-Zeichen
    private let serviceType = "unoexperience"
    //Peer-ID für ausführendes Gerät
    private var myPeerId = MCPeerID(displayName: "Host")
    //Advertiser & Browser zum suchen und finden anderer Geräte
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    //Session, über die Daten empfangen und ausgelesen werden können
    private let session: MCSession
    //Logger für Konsole
    private let log = Logger()
    
    //öffentliche Variablen
    //Liste mit allen verbundenen Geräten
    @Published var connectedPeers: [MCPeerID] = []
    //aktuelle Ansicht auf den Geräten...
    
    //Variable um auf GameEngine zuzugreifen
    @Published var gameHandler: GameEngine!
    
    //initializer
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        gameHandler = GameEngine(sessionHandler: self)
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
        
        
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    //Jeder gesendete Traffic läuft hierüber
    func sendTraffic(recipient: String, prefix: String, packet1: String, packet2: String) {
        
        print(("Daten \(recipient + ":" + prefix + ":" + packet1 + ":" + packet2) gesendet"))
        
        let data = String(recipient + "#" + prefix + "#" + packet1 + "#" + packet2).data(using: .isoLatin1)!
        
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            log.error("Error beim senden: \(String(describing: error))")
        }
    }
    
    
    //Der gesamte Datenverkehr läuft über diese Funktion
    func trafficHandler(data: Data, peerID: MCPeerID) {
        DispatchQueue.main.async {
            //Logging
            self.log.info("Datenpaket: \(String(data: data, encoding: .isoLatin1)!) empfangen.")
            
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
            
            if (decodedDataArray[1] != TargetNames.host.rawValue) && (decodedDataArray[1] != TargetNames.allDevices.rawValue) {return}
            
            
            switch decodedDataArray[2] {
                
            case TrafficTypes.gameActionIdentifier.rawValue:
                
                switch decodedDataArray[3] {
                    
                case GameActions.win.rawValue:
                    self.gameHandler.endGameHandler(winnerName: decodedDataArray[4])
                case GameActions.stopGame.rawValue:
                    self.gameHandler.endGameHandler(winnerName: "")
                    
                default:
                    self.log.error("Fehler bei der Übertragung eines GameAction Packetes")
                    
                }
                
            case TrafficTypes.cardActionIdentifier.rawValue:
                
                switch decodedDataArray[3] {
                    
                case CardActions.playCard.rawValue:
                    self.gameHandler.changeCard(cardRawValue: decodedDataArray[4])
                case CardActions.requestCard.rawValue:
                    self.gameHandler.drawHandler(recipient: decodedDataArray[0], amount: Int(decodedDataArray[4])!)
                default:
                    self.log.error("Fehler bei der Übertragung eines CardAction Packetes")
                    
                }
                
                
                
            default:
                self.log.error("Fehler bei Packetübertragung")
                
            }
            
            
            
            
        }
    }
    
    func stopConnectionMode() {
        self.serviceBrowser.stopBrowsingForPeers()
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
}

//Nötiger Code von Vererbungen des ServiceAdvertisers
extension MP_Session: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        
    }
    
}

//automatisches Senden von Einladungen
extension MP_Session: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 5)
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
        
    }
    
}

//Ausführung wenn sich der Status eines Gerätes im Netz geändert hat
extension MP_Session: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        
        DispatchQueue.main.async {
            self.connectedPeers = session.connectedPeers
        }
        
    }
    
    //Ausführung wenn Daten empfangen werden -> Weiterleitung an trafficHandler der GameEngine
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        log.info("didReceive bytes \(data.count) bytes")
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

