//
//  MP_Session.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//

import MultipeerConnectivity
import Foundation
import os

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
    //True wenn genau 2 Geräte verbunden
    @Published var isReady: Bool = false
    //aktuelle Ansicht auf den Geräten...
    //To-DO PLanung Ansichten (wahrscheinlich 1. Hauptmenü, 2. Spielmenü, 2.1 Unokarten mit ListView
    @Published var viewState: ViewStates = .mainMenu

    //Variable um auf GameEngine zuzugreifen
    @Published var gameHandler: GameEngine!
    @Published var activeCard: Cards = Card.getRandom(id: 1).type
    //@Published var activePlayer: ActivePlayer = .playerOne
    @Published var hasPlayed: Bool = false


    //initializer
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)

        super.init()

        self.gameHandler = GameEngine(sessionHandler: self)

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

    func sendTraffic(data: Data) {
        self.log.info("Daten gesendet an \(self.session.connectedPeers) Geräte")

        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            log.error("Error for sending: \(String(describing: error))")
        }
    }


}

extension MP_Session: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")

    }

}

//automatisches Senden von Einladungen und Trennen der Verbindung bei Abbrüchen
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

            if self.connectedPeers.count == 2 {
                self.isReady = true
            } else {
                self.isReady = false
            }
        }


    }

    //Ausführung wenn Daten empfangen werden -> Weiterleitung an trafficHandler der GameEngine
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        log.info("didReceive bytes \(data.count) bytes")
        self.gameHandler.trafficHandler(data: data)
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

