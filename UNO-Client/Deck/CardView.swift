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
                    //Wenn Spieler schon gelegt hat
                    if sessionHandler.gameHandler.hasPlayed == true {
                        return
                    }
                    //Wenn Wünsche auf Wünsche gelegt wird
                    if card.type.number == -1 && sessionHandler.gameHandler.activeCard.number == -1 {return}
                    
                    //Wenn Spieler Wünschekarte legt
                    if card.type == Cards.CHOOSE {
                        showColorPicker = true
                        return
                    }

                    //Wenn Farbe oder Nummer übereinstimmt
                    if (card.type.color == sessionHandler.gameHandler.activeCard.color || card.type.number == sessionHandler.gameHandler.activeCard.number) {
                        //Animation verschwinden im Deck
                        withAnimation(.easeInOut(duration: 0.35)) {
                            self.size -= 1
                        }
                        //Nach Animation Code ausführen:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.playCard.rawValue, packet2: card.type.rawValue)


                            //Entferne Karte aus Stapel
                            sessionHandler.gameHandler.cardDeck.remove(at: sessionHandler.gameHandler.cardDeck.firstIndex(where: { $0 == self.card })!)
                            
                            //Setze Karte ziehen Knopf zurück
                            sessionHandler.gameHandler.hasDrawn = false
                            sessionHandler.gameHandler.hasPlayed = true

                            //Wenn Aussatzen, dann kann nochmal gelegt werden
                            if card.type.number == -2 {
                                sessionHandler.gameHandler.hasPlayed = false
                            }
                        }

                    }

                    sessionHandler.gameHandler.activeCard = self.card.type
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
