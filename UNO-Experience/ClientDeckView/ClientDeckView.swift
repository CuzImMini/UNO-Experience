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
    @EnvironmentObject var sessionHandler: ClientSessionManager
    
    //Farbe des Skip-Buttons
    @State var skipButtonColor: Color = .red
    @State var drawButtonColor: Color = .blue
    
    //Logger für Konsole
    let log = Logger()
    
    
    var body: some View {
        
        VStack {
            //Top-Bar zur Anzeige des Spielers und der übrigen Karten
            VStack {
                HStack {
                    Button("Abbruch") {
                        sessionHandler.gameHandler.cancelGame(selfInitiated: true)
                        
                    }.padding(10).foregroundColor(.white).buttonStyle(.bordered).tint(.white)
                    Spacer()
                    Text("Hier sind \(sessionHandler.gameHandler.cardDeck.count) UNO Karten!").padding(.trailing, 25).foregroundColor(.white).underline()
                }
                if sessionHandler.gameHandler.hasPlayed {
                    Text("Anderer Spieler am Zug").foregroundColor(.white).padding(5).padding(.bottom, 10)
                } else {
                    Text("Du bist dran!").foregroundColor(.white).padding(5).padding(.bottom, 10)
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.9, green: 0, blue: 0), Color(red: 0, green: 0, blue: 0.9)]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            
            //GeometryReader zum auslesen der Größe
            GeometryReader() {geo in
                //ScrollViewReader um die Karten scrollbar zu machen
                ScrollViewReader { scrollView in
                    
                    Spacer()
                    //ScrollView zur Anzeige der scrollbaren UNO Karten
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(sessionHandler.gameHandler.cardDeck) { card in
                                ClientCardView(card: card, sessionHandler: sessionHandler, initialImageSize: geo.size).id(card.id)
                            }
                            
                        }.padding(.vertical, 50)
                        
                    }
                    .frame(height: (geo.size.height/1.5))
                    Spacer()
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
                        .foregroundColor(drawButtonColor)
                        .tint(drawButtonColor)
                        .buttonStyle(.bordered)
                        .padding(20)
                        //Aktionen wenn Spielereignis eintrifft
                        //Scrollen zu neuen Karten
                        .onChange(of: sessionHandler.gameHandler.cardDeck.count) { count in
                            //Wenn eine Karte dazu gekommen ist, scrolle zur neuen Karte
                            if sessionHandler.gameHandler.lastDeckCount ?? 0 < count {
                                withAnimation(.easeInOut(duration: 1000)) {
                                    scrollView.scrollTo(sessionHandler.gameHandler.cardDeck.last!.id, anchor: .trailing)
                                }
                            }
                            sessionHandler.gameHandler.lastDeckCount = count
                            
                            if count == 0 {
                                sessionHandler.gameHandler.winHandler()
                            }
                            
                        }
                        //Scrollen zu passenden Karten
                        .onChange(of: sessionHandler.gameHandler.hasPlayed) {bool in
                            if !bool {
                                guard let fittingCardIndex: Int = sessionHandler.gameHandler.cardDeck.first(where: {$0.type.color == sessionHandler.gameHandler.activeCard.color || $0.type.number == sessionHandler.gameHandler.activeCard.number})?.id else {
                                    
                                    guard let fittingChooseCardIndex: Int = sessionHandler.gameHandler.cardDeck.first(where: {$0.type == Cards.CHOOSE})?.id else {return}
                                    withAnimation(.easeInOut(duration: 1000)) {
                                        scrollView.scrollTo(fittingChooseCardIndex, anchor: .center)
                                    }
                                    return
                                }
                                withAnimation(.easeInOut(duration: 1000)) {
                                    scrollView.scrollTo(fittingCardIndex, anchor: .center)
                                }
                                
                            }
                        }
                        //Änderung der Farben von nöpfen
                        .onChange(of: sessionHandler.gameHandler.hasDrawn) { hasDrawn in
                            
                            if hasDrawn {
                                skipButtonColor = .blue
                                drawButtonColor = .red
                            } else {
                                skipButtonColor = .red
                                drawButtonColor = .blue
                            }
                        }
                            Button("Aussetzen") {
                                if !sessionHandler.gameHandler.hasDrawn {return}
                                sessionHandler.gameHandler.skipHandler()
                                /*
                                    sessionHandler.sendTraffic(recipient: TargetNames.host.rawValue, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.requestSkip.rawValue, packet2: "")
                                    sessionHandler.gameHandler.hasDrawn = false
                                    sessionHandler.gameHandler.hasPlayed = true
                                */
                                
                            }
                            .foregroundColor(skipButtonColor)
                            .tint(skipButtonColor)
                            .padding(20)
                            .buttonStyle(.bordered)
                            
                            
                        }
                    }
                } //Geometry Reader
            }
            .background(Color("ClientBackgroundColor"))
            .toolbar(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden()
            
            
            
        }
        
    
}

struct ClientDeckView_Previews: PreviewProvider {
    
    
    static var previews: some View {
            ClientDeckView().environmentObject(ClientSessionManager())
        
        
    }
}

