//
//  CardView.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 26.01.23.
//

import SwiftUI
import os

struct CardView: View {

    @State var card: Card
    @State var sessionHandler: MP_Session
    @State var showColorPicker: Bool = false
    var clientDeckView: ClientDeckView
    
    let log = Logger()

    @Binding var cardDeck: [Card]

    var body: some View {

        Button(card.type.description) {
            log.info("************")
            log.info("aktive Karte: \(card.type.description) mit Farbe \(card.type.color) und Zahl \(card.type.number)")
            log.info("Karte auf dem Stapel: \(sessionHandler.activeCard.description)")
            log.info("------------")
            //DEBUG
            log.info("Erstelle Karten-Log:")
            for object in cardDeck {
                
                log.info("Karte \(object.type.description) an Stelle \(object.id)")
                
            }
            log.info("------------")

            if sessionHandler.hasPlayed == true {
                log.info("Zug nicht möglich... Spieler hat bereits gelegt!")
                return
            }
            if card.type == Cards.CHOOSE {
                log.info("Wünschekarte ausgespielt!")
                showColorPicker = true

            }

            if (card.type.color == sessionHandler.activeCard.color || card.type.number == sessionHandler.activeCard.number) {
                log.info("Karte ausgespielt!")
                sessionHandler.sendTraffic(data: card.type.rawValue.data(using: .isoLatin1)!)
                sessionHandler.hasPlayed = true
                
                cardDeck.remove(at: card.id)

                for object in cardDeck {
                    if object.id > card.id {
                        object.id -= 1
                    }
                }
            }
            clientDeckView.skipButtonColor = .red
            
            if cardDeck.count == 0 {
                sessionHandler.gameHandler.winHandler()
                log.info("Gewonnen")

            }
            log.info("************")

        }
                .buttonStyle(.bordered)
                .foregroundColor(card.type.color)
                .padding(.horizontal, 10)
                .popover(isPresented: $showColorPicker) {
                    ColorPickerView(cardView: self, showColorPicker: $showColorPicker, cardDeck: $cardDeck).environmentObject(sessionHandler)
                }

    }


}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(id: 1, type: .RED_ZERO), sessionHandler: MP_Session(), cardDeck: .constant([Card(id: 1, type: .RED_ZERO)]))
    }
}
