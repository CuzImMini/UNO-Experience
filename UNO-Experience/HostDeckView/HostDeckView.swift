//
//  HostDeckView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 07.04.23.
//

import SwiftUI

struct HostDeckView: View {
    
    @EnvironmentObject var sessionHandler: HostSessionManager
    
    var body: some View {
        //Reader für Bildschirmgröße
            GeometryReader() {geo in
            //Ganzer View in VStack
            VStack {
                //Knopf zum Zurückkehren
                HStack() {
                    Button("Abbruch") {
                        sessionHandler.gameHandler.cancelGame(selfInitiated: true)
                    }.padding(10).foregroundColor(.white).buttonStyle(.bordered).tint(.white)
                    Spacer()
                }
                //Anzeige Spieler und Karte 1
                HStack() {
                    Text(sessionHandler.gameHandler.activeCard.description).foregroundColor(.white)
                    Divider().padding(.horizontal, 15).tint(.white).frame(maxHeight: 25)
                    Text("\(sessionHandler.gameHandler.players[sessionHandler.gameHandler.activePlayerIndex]) ist am Zug!").foregroundColor(.white)
                }
                .rotationEffect(Angle(degrees: 180))
                .padding(geo.size.height/50)
                Spacer()
                //Kartenstapel
                ZStack {
                    ForEach(sessionHandler.gameHandler.cardStack) { card in
                        
                        if sessionHandler.gameHandler.cardStack.count - card.id < 16 && sessionHandler.gameHandler.cardStack.count - card.id != 1 {
                            
                            HostCardStackView(card: card.type, rotationDegree: card.rotationDegree ?? 0, animationCard: false).id(card.id)
                        }
                        if sessionHandler.gameHandler.cardStack.count - card.id == 1 {
                            //oberste Karte mit aktivierten Animationen
                            HostCardStackView(card: card.type, rotationDegree: card.rotationDegree ?? 0, animationCard: true).id(card.id)
                            
                            
                        }
                        
                    }
                    
                }
                .frame(maxWidth: geo.size.width, maxHeight: 650)
                Spacer()
                //Anzeige Spieler und Karte 2
                HStack() {
                    Text(sessionHandler.gameHandler.activeCard.description).foregroundColor(.white)
                    Divider().padding(.horizontal, 15).tint(.white).frame(maxHeight: 25)
                    Text("\(sessionHandler.gameHandler.players[sessionHandler.gameHandler.activePlayerIndex]) ist am Zug!").foregroundColor(.white)
                }.padding(geo.size.height/50)
                
            }
            .background(Color("HostBackgroundColor"))
            }.navigationBarBackButtonHidden(true).toolbar(.hidden, for: .navigationBar)
        
        
    }
}

struct HostDeckView_Previews: PreviewProvider {
    static var previews: some View {
        HostDeckView().environmentObject(HostSessionManager())
    }
}
