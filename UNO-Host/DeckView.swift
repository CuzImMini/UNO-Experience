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
            Text(sessionHandler.activeCard.description).foregroundColor(.white).rotationEffect(Angle(degrees: 180))
            Spacer()
            ZStack {
                ForEach(sessionHandler.cardStack) { card in

                    if sessionHandler.cardStack.count - card.id < 16 && sessionHandler.cardStack.count - card.id != 1 {
                        CardStackView(card: card.type, rotationRadian: card.rotationRadian ?? 0, animationCard: false).id(card.id)
                    }
                    if sessionHandler.cardStack.count - card.id == 1 {
                        //oberste Karte

                        CardStackView(card: card.type, rotationRadian: card.rotationRadian ?? 0, animationCard: true).id(card.id)


                    }

                }

            }
                    .frame(maxWidth: 350, maxHeight: 650)
            Spacer()
            Text(sessionHandler.activeCard.description).foregroundColor(.white)
            Spacer().frame(maxHeight: 100)


        }
                .background(.gray)

    }

}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView().environmentObject(MP_Session())
    }
}
