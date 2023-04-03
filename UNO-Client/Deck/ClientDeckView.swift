//
//  ClientDeckView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI
import os


struct ClientDeckView: View {

    //Übergabe der Variable um auf Session- & Gamehandler zugreifen zu können
    @EnvironmentObject var sessionHandler: MP_Session

    //Variable, die zeigt ob bereits eine Karte gezogen wurde
    //Farbe des Skip-Buttons
    @State var skipButtonColor: Color = .red


    @State var lastDeckCount: Int = 8

    //Logger für Konsole
    let log = Logger()

    var body: some View {
        VStack {
            Spacer()
            Text("Hier sind \(sessionHandler.cardDeck.count) UNO Karten!").padding(20)

            if sessionHandler.hasPlayed {
                Text("Anderer Spieler am Zug")
            } else {
                Text("Du bist dran!")
            }

            Spacer()

            ScrollViewReader { scrollView in
                ScrollView(.horizontal) {
                    HStack() {
                        ForEach(sessionHandler.cardDeck) { card in


                            CardView(card: card, sessionHandler: sessionHandler).id(card.id)
                        }

                    }
                            .frame(height: 600)

                }

                        .frame(width: 390, height: 650)


                Spacer().frame(maxHeight: 100)
                HStack(spacing: 30) {

                    Button("Karte ziehen") {
                        if (sessionHandler.gameHandler.hasDrawn || sessionHandler.hasPlayed) {
                            return
                        }
                        log.info("Karte gezogen!")

                        //Hole neue Karte vom Wahrscheinlichkeitsstapel
                        sessionHandler.gameHandler.requestDraw(amount: 1)

                        sessionHandler.gameHandler.hasDrawn = true
                    }
                            .buttonStyle(.bordered)
                            .padding(20)
                            .onChange(of: sessionHandler.cardDeck.count) { count in

                                if lastDeckCount < count {
                                    withAnimation(.easeInOut(duration: 250)) {
                                        scrollView.scrollTo(sessionHandler.cardDeck.last!.id, anchor: .trailing)
                                    }
                                }
                                lastDeckCount = count

                                if count == 0 {
                                    sessionHandler.gameHandler.winHandler()
                                }

                            }

                    Button("Aussetzen") {
                        if sessionHandler.gameHandler.hasDrawn {
                            sessionHandler.sendTraffic(data: GameTraffic.skip.rawValue.data(using: .isoLatin1)!)
                            sessionHandler.gameHandler.hasDrawn = false
                            sessionHandler.hasPlayed = true
                        }

                    }
                            .buttonStyle(.bordered)
                            .padding(20)
                            .foregroundColor(skipButtonColor)
                            .onChange(of: sessionHandler.gameHandler.hasDrawn) { hasDrawn in

                                if hasDrawn {
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
