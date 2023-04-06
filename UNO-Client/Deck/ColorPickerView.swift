//
// Created by Paul Cornelissen on 26.01.23.
//

import Foundation
import SwiftUI

struct ColorPickerView: View {

    @EnvironmentObject var sessionHandler: MP_Session
    @Binding var showColorPicker: Bool

    var card: Card

    var body: some View {

        VStack(spacing: 50) {
            Text("Wähle eine Farbe").padding(.vertical, 100).font(.system(size: 20))
            Spacer().frame(maxHeight: 100)
            HStack(spacing: 50) {
                ZStack() {
                    Rectangle().frame(width: 150, height: 150).foregroundColor(Color(red: 0.85, green: 0, blue: 0)).cornerRadius(15)
                    Text("Rot").foregroundColor(.white)
                }
                        .onTapGesture {
                            colorPickHandler(card: .R_CHOOSE)
                        }
                ZStack() {
                    Rectangle().frame(width: 150, height: 150).foregroundColor(.blue).cornerRadius(15)
                    Text("Blau").foregroundColor(.white)
                }
                        .onTapGesture {
                            colorPickHandler(card: .B_CHOOSE)
                        }
            }
            HStack(spacing: 50) {
                ZStack() {
                    Rectangle().frame(width: 150, height: 150).foregroundColor(.green).cornerRadius(15)
                    Text("Grün").foregroundColor(.white)
                }
                        .onTapGesture {
                            colorPickHandler(card: .G_CHOOSE)
                        }
                ZStack() {
                    Rectangle().frame(width: 150, height: 150).foregroundColor(.yellow).cornerRadius(15)
                    Text("Gelb").foregroundColor(.white)
                }
                        .onTapGesture {
                            colorPickHandler(card: .Y_CHOOSE)
                        }

            }


            Spacer()
        }
    }

    func colorPickHandler(card: Cards) {
        sessionHandler.sendTraffic(recipient: TargetNames.allDevices.rawValue, prefix: TrafficTypes.cardActionIdentifier.rawValue, packet1: CardActions.playCard.rawValue, packet2: card.rawValue)

        sessionHandler.gameHandler.hasDrawn = false
        sessionHandler.gameHandler.hasPlayed = true
        showColorPicker = false

        sessionHandler.gameHandler.cardDeck.remove(at: sessionHandler.gameHandler.cardDeck.firstIndex(where: { $0 == self.card })!)


        sessionHandler.gameHandler.activeCard = card

        if sessionHandler.gameHandler.cardDeck.count == 0 {
            sessionHandler.gameHandler.winHandler()

        }

    }


}

struct ColorPicker_Preview: PreviewProvider {
    static var previews: some View {
        ColorPickerView(showColorPicker: .constant(true), card: Card(id: 1, type: .CHOOSE))
    }
}
