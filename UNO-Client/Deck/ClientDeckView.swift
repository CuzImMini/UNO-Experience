//
//  ClientDeckView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI
import os


struct ClientDeckView: View {

    @EnvironmentObject var sessionHandler: MP_Session

   // @StateObject var cardDeck: CardDeckObject = CardDeckObject(cards: Card.getRandom(amount: 8))
    @State var cardDeck: [Card] = Card.getRandom(amount: 8)

    //Wird zum scrollen verwendet
    @State private var scrollTarget: Int?

    @State var hasDrawn: Bool = false
    let log = Logger()

    var body: some View {
        VStack() {
            Spacer()
            Text("Hier kommen UNO Karten!")

            if sessionHandler.hasPlayed {
                Text("Anderer Spieler am Zug")
            } else {
                Text("Du bist dran!")
            }

            Spacer()

            ScrollViewReader { (proxy: ScrollViewProxy) in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(cardDeck) { card in
                            VStack {
                                CardView(card: card, sessionHandler: sessionHandler, cardDeck: $cardDeck)
                                Text(card.type.description)
                            }
                        }
                    }


                }
                        .onChange(of: scrollTarget) { target in
                            if let target = target {
                                scrollTarget = nil

                                withAnimation {
                                    proxy.scrollTo(target, anchor: .center)
                                }
                            }
                        }

                Spacer().frame(maxHeight: 100)

                HStack(spacing: 30) {

                    Button("Karte ziehen") {
                        cardDeck.append(Card.getRandom(id: cardDeck.count + 1))
                        scrollTarget = cardDeck.count
                        hasDrawn.toggle()

                    }
                            .buttonStyle(.bordered)
                            .padding(20)
                    Button("Aussetzen") {
                        if hasDrawn {
                            sessionHandler.sendTraffic(data: GameTraffic.skip.rawValue.data(using: .isoLatin1)!)
                            hasDrawn.toggle()
                        }


                    }
                            .buttonStyle(.bordered)
                            .padding(20)
                }
            }
        }
    }


}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDeckView().environmentObject(MP_Session())
    }
}
