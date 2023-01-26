//
//  DeckView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct DeckView: View {

    @EnvironmentObject var engine: MP_Session

    @State var cardDeck: [Card] = Card.getRandom(amount: 8)

    var body: some View {
        VStack() {
            Spacer()
            Text("Hier kommen UNO Karten!")
            if engine.hasPlayed {
                Text("Anderer Spieler am Zug")
            } else {
                Text("Du bist dran!")
            }
            Spacer()

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(cardDeck) { card in
                        HStack() {
                            CardView(card: card, engine: engine, cardDeck: $cardDeck)
                        }
                    }
                }
                        .frame(height: 200)
            }


            Spacer()
            Button("Karte ziehen") {
                cardDeck.append(Card(id: cardDeck.count + 1, type: Cards.allCases.randomElement() ?? .BLUE_ONE))
            }
                    .buttonStyle(.bordered)
                    .padding(20)
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView().environmentObject(MP_Session())
    }
}
