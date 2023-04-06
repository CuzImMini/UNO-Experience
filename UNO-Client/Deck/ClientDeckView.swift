//
//  ClientDeckView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI
import os


struct ClientDeckView: View {
    
    //Übergabe der Variable um auf Session- & Gamehandler zugreifen zu können
    @EnvironmentObject var sessionHandler: MP_Session
    
    //Farbe des Skip-Buttons
    @State var skipButtonColor: Color = .red
    //Letzte Anzahl an Karten auf der Hand
    @State var lastDeckCount: Int = 8
    
    //Logger für Konsole
    let log = Logger()
    
    var body: some View {
        
        VStack {
            //Top-Bar zur Anzeige des Spielers und der übrigen Karten
            VStack {
                Text("Hier sind \(sessionHandler.gameHandler.cardDeck.count) UNO Karten!")
                
                if sessionHandler.gameHandler.hasPlayed {
                    Text("Anderer Spieler am Zug")
                } else {
                    Text("Du bist dran!")
                }
            }.padding(10)
            //ScrollViewReader um die Karten scrollbar zu machen
            ScrollViewReader { scrollView in
                //ScrollView zur Anzeige der scrollbaren UNO Karten
                ScrollView(.horizontal) {
                    HStack() {
                        ForEach(sessionHandler.gameHandler.cardDeck) { card in
                            
                            
                            CardView(card: card, sessionHandler: sessionHandler).id(card.id)
                        }
                        
                    }
                    .frame(maxHeight: 600)
                    
                }
                .frame(maxWidth: 390, maxHeight: 650)
                //Platz für die beiden Knöpfe
                HStack(spacing: 30) {
                    Button("Karte ziehen") {
                        if (sessionHandler.gameHandler.hasDrawn || sessionHandler.gameHandler.hasPlayed) {
                            return
                        }                        
                        //Hole neue Karte vom Wahrscheinlichkeitsstapel
                        sessionHandler.gameHandler.requestDraw(amount: 1)
                        
                        sessionHandler.gameHandler.hasDrawn = true
                    }
                    .buttonStyle(.bordered)
                    .padding(20)
                    //Aktionen wenn Spielereignis eintrifft
                    .onChange(of: sessionHandler.gameHandler.cardDeck.count) { count in
                        //Wenn eine Karte dazu gekommen ist, scrolle zur neuen Karte
                        if lastDeckCount < count {
                            withAnimation(.easeInOut(duration: 400)) {
                                scrollView.scrollTo(sessionHandler.gameHandler.cardDeck.last!.id, anchor: .trailing)
                            }
                        }
                        lastDeckCount = count
                        
                        if count == 0 {
                            sessionHandler.gameHandler.winHandler()
                        }
                        
                    }
                    .onChange(of: sessionHandler.gameHandler.hasPlayed) {bool in
                        if !bool {
                            guard let fittingCardIndex: Int = sessionHandler.gameHandler.cardDeck.first(where: {$0.type.color == sessionHandler.gameHandler.activeCard.color || $0.type.number == sessionHandler.gameHandler.activeCard.number})?.id else {
                                
                                guard let fittingChooseCardIndex: Int = sessionHandler.gameHandler.cardDeck.first(where: {$0.type == Cards.CHOOSE})?.id else {return}
                                withAnimation(.easeInOut(duration: 500)) {
                                    scrollView.scrollTo(fittingChooseCardIndex, anchor: .center)
                                }
                                return
                            }
                                withAnimation(.easeInOut(duration: 500)) {
                                    scrollView.scrollTo(fittingCardIndex, anchor: .center)
                                }
                            
                        }
                    }
                    .onChange(of: sessionHandler.gameHandler.hasDrawn) { hasDrawn in
                        
                        if hasDrawn {
                            skipButtonColor = .blue
                        } else {
                            skipButtonColor = .red
                        }
                    }
                    
                    Button("Aussetzen") {
                        if sessionHandler.gameHandler.hasDrawn {
                            sessionHandler.sendTraffic(recipient: TargetNames.allPlayers.rawValue, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.requestSkip.rawValue, packet2: "")
                            sessionHandler.gameHandler.hasDrawn = false
                            sessionHandler.gameHandler.hasPlayed = true
                        }
                        
                    }
                    .buttonStyle(.bordered)
                    .padding(20)
                    .foregroundColor(skipButtonColor)
                    
                    
                }
            }
            .background(Color(uiColor: .lightGray))
        }
        
        
    }
    
    
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDeckView().environmentObject(MP_Session())
    }
}
