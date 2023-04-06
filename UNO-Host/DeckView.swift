//
//  ClientDeckView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct DeckView: View {

    @EnvironmentObject var sessionHandler: MP_Session

    var body: some View {

        VStack {

            HStack {
                Button("Zurück") {
                    sessionHandler.gameHandler.cancelGame()
                }
                        .padding(25)
                        .foregroundColor(.white)
                Spacer()

            }
            Spacer().frame(maxHeight: 100)
            Text(sessionHandler.gameHandler.activeCard.description).foregroundColor(.white).rotationEffect(Angle(degrees: 180))
            Spacer()
            ZStack {
                ForEach(sessionHandler.gameHandler.cardStack) { card in

                    if sessionHandler.gameHandler.cardStack.count - card.id < 16 && sessionHandler.gameHandler.cardStack.count - card.id != 1 {
                        
                        CardStackView(card: card.type, rotationDegree: card.rotationDegree ?? 0, animationCard: false).id(card.id)
                    }
                    if sessionHandler.gameHandler.cardStack.count - card.id == 1 {
                        //oberste Karte mit aktivierten Animationen
                        CardStackView(card: card.type, rotationDegree: card.rotationDegree ?? 0, animationCard: true).id(card.id)


                    }

                }

            }
                    .frame(maxWidth: 350, maxHeight: 650)
            Spacer()
            Text(sessionHandler.gameHandler.activeCard.description).foregroundColor(.white)
            Spacer().frame(maxHeight: 100)


        }
                .background(.gray)

    }

}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
            .environmentObject(MP_Session())
    }
}
