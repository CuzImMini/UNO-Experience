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
    
    let log = Logger()

    @Binding var cardDeck: [Card]

    var body: some View {

        Button(card.type.description) {
            if sessionHandler.hasPlayed == true {
                return
            }
            if card.type == Cards.CHOOSE {
                showColorPicker = true

            }

            if (card.type.color == sessionHandler.activeCard.color || card.type.number == sessionHandler.activeCard.number) {
                sessionHandler.sendTraffic(data: card.type.rawValue.data(using: .isoLatin1)!)
                sessionHandler.hasPlayed = true
            }
            log.info("Das Array ist \(cardDeck.count) groß!")
            cardDeck.remove(at: card.id)
            log.info("Die Karte \(card.type.description) mit der ID \(card.id) wurde aus dem Array entfernt.")
            
            

            for object in cardDeck {
                if object.id > card.id {
                    object.id -= 1
                }
            }

            for card in cardDeck {
                log.info("Karte bei Index \(card.id) ist eine \(card.type.description) Karte")
            }
            
            if cardDeck.count == 0 {
                sessionHandler.sendTraffic(data: GameTraffic.win.rawValue.data(using: .isoLatin1)!)

            }

        }
                .buttonStyle(.bordered)
                .foregroundColor(card.type.color)
                .padding(.horizontal, 10)
                .popover(isPresented: $showColorPicker) {
                    ColorPickerView(card: self, showColorPicker: $showColorPicker).environmentObject(sessionHandler)
                }

    }


}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(id: 1, type: .RED_ZERO), sessionHandler: MP_Session(), cardDeck: .constant([Card(id: 1, type: .RED_ZERO)]))
    }
}
