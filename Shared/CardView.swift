//
//  CardView.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 26.01.23.
//

import SwiftUI

struct CardView: View {

    @State var card: Card
    @State var engine: MP_Session
    @State var visible: Bool = true
    @State var showColorPicker: Bool = false

    @Binding var cardDeck: [Card]

    var body: some View {

        switch self.visible {

        case true:
            Button(card.type.description) {
                if engine.hasPlayed == true {
                    return
                }
                if card.type == Cards.CHOOSE {
                    showColorPicker = true
                }

                if (card.type.color == engine.activeCard.color || card.type.number == engine.activeCard.number) {

                    engine.sendTraffic(data: card.type.rawValue.data(using: .isoLatin1)!)
                    self.visible = false
                    self.card.visible = false
                    engine.hasPlayed = true
                }

                for card in cardDeck {
                    var win: Bool = true
                    if card.visible {
                        win = false
                        break
                    }
                    if win {
                        engine.sendTraffic(data: GameTraffic.win.rawValue.data(using: .isoLatin1)!)
                        print("GEWONNEN")
                    }
                }

            }
                    .buttonStyle(.bordered)
                    .foregroundColor(card.type.color)
                    .padding(10)
                    .popover(isPresented: $showColorPicker) {
                        ColorPickerView(card: self, showColorPicker: $showColorPicker).environmentObject(engine)
                    }
        case false:
            Spacer().frame(width: 0, height: 0)
        }


    }

    func isVisible() -> Bool {
        visible
    }

}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(id: 1, type: .RED_ZERO), engine: MP_Session(), cardDeck: .constant([Card(id: 1, type: .RED_ZERO)]))
    }
}
