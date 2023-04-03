//
//  CardView.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 26.01.23.
//

import SwiftUI
import os

struct CardView: View {

    //Variable die sagt, welche Karte der View repräsentiert
    @State var card: Card
    //Variable um auf Session- & Gamehandler zuzugreifen
    @State var sessionHandler: MP_Session

    //Variable die Popup steuert
    @State var showColorPicker = false

    //Logger für Konsole
    let log = Logger()

    @State var size: Double = 1


    var body: some View {

        //Kartenbild
        Image(card.type.rawValue)
                .resizable()
                .frame(maxWidth: 250, maxHeight: 450)
                .padding(.horizontal, 5)
                .scaleEffect(CGFloat(size))

                //Geste beim Spielen der Karte
                .onTapGesture {

                    //LOG-Anfang
                    /*
                log.info("geklickte Karte: \(card.type.description) mit Farbe \(card.type.color) und Zahl \(card.type.number)")
                log.info("Karte auf dem Stapel: \(sessionHandler.activeCard.description)")
                
                log.info("Erstelle Karten-Log:")
                for object in sessionHandler.cardDeck {
                    
                    log.info("Karte \(object.type.description) an Stelle \(object.id)")
                    
                }
                */
                    //LOG-Ende

                    if sessionHandler.hasPlayed == true {
                        log.warning("Zug nicht möglich... Spieler hat bereits gelegt!")
                        return
                    }
                    if card.type == Cards.CHOOSE && sessionHandler.activeCard.number != -1 {
                        log.info("Wünschekarte ausgespielt! ShowColorPicker = \(showColorPicker)")
                        showColorPicker = true
                        return
                    }

                    if (card.type.color == .black || card.type.number == -1) {
                        return
                    }
                    if (card.type.color == sessionHandler.activeCard.color || card.type.number == sessionHandler.activeCard.number) {

                        withAnimation(.easeInOut(duration: 0.25)) {

                            self.size -= 1

                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

                            log.info("Karte \(card.type.description) auf \(sessionHandler.activeCard.description) gelegt!")

                            sessionHandler.sendTraffic(data: card.type.rawValue.data(using: .isoLatin1)!)

                            if card.type.number != -2 {
                                sessionHandler.hasPlayed = true
                            }
                            sessionHandler.cardDeck.remove(at: sessionHandler.cardDeck.firstIndex(where: { $0 == self.card })!)
                            sessionHandler.gameHandler.hasDrawn = false
                        }

                    }

                    sessionHandler.activeCard = self.card.type
                }
                .popover(isPresented: $showColorPicker) {
                    ColorPickerView(showColorPicker: $showColorPicker, card: self.card).environmentObject(sessionHandler)
                }


    }


}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(id: 1, type: .RED_ZERO), sessionHandler: MP_Session())
    }
}
