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

    @State var cardDeck: [Card] = Card.getRandom(amount: 8)
    @State var refreshDummy: Bool = false

    @State var hasDrawn: Bool = false
    @State var skipButtonColor: Color = .blue

    let log = Logger()

    var body: some View {
        VStack {
            Spacer()
            Text("Hier kommen UNO Karten!")

            if sessionHandler.hasPlayed {
                Text("Anderer Spieler am Zug")
            } else {
                Text("Du bist dran!")
            }

            Spacer()

            ScrollViewReader { scrollView in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(cardDeck) { card in
                            CardView(card: card, sessionHandler: sessionHandler, clientDeckView: self, cardDeck: $cardDeck).id(UUID())

                        }

                    }
                            .frame(height: 600)

                }


                Spacer().frame(maxHeight: 100)

                HStack(spacing: 30) {

                    Button("Karte ziehen") {
                        print("Karte gezogen!")
                        if hasDrawn {
                            return
                        }
                        cardDeck.append(Card.getRandom(id: cardDeck.count))

                        scrollView.scrollTo(cardDeck.last!.id, anchor: .center)
                        hasDrawn = true
                    }
                            .buttonStyle(.bordered)
                            .padding(20)

                    Button("Aussetzen") {
                        if hasDrawn {
                            sessionHandler.sendTraffic(data: GameTraffic.skip.rawValue.data(using: .isoLatin1)!)
                            hasDrawn = false
                            sessionHandler.hasPlayed = true
                        }

                    }
                            .buttonStyle(.bordered)
                            .padding(20)
                            .foregroundColor(skipButtonColor)
                            .onChange(of: hasDrawn) { value in

                                if value {
                                    skipButtonColor = .blue
                                } else {
                                    skipButtonColor = .red
                                }
                            }

                }
            }
                    .background(Color(uiColor: .lightGray))
        }

    }


}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDeckView().environmentObject(MP_Session())
    }
}
