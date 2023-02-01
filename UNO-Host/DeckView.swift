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
                    self.sessionHandler.gameHandler.cancelGame()
                }
                        .padding(25)
                        .foregroundColor(.white)
                Spacer()

            }

            Spacer()
            ZStack {
                ForEach(sessionHandler.cardStack) { card in
                    CardStackView(card: card.type, rotationRadian: card.rotationRadian ?? 0).id(UUID())


                }

            }
                    .frame(maxWidth: 350, maxHeight: 650)

            Spacer()


        }
                .background(.gray
                )

    }

}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView().environmentObject(MP_Session())
    }
}
