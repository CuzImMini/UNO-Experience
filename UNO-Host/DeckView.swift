//
//  DeckView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct DeckView: View {

    @EnvironmentObject var engine: MP_Session

    var body: some View {

        VStack {

            HStack {
                Button("Zurück") {
                    self.engine.gameHandler.cancelGame()
                }
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 25)
                Spacer()
                Button(engine.activePlayer.rawValue) {
                }
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 25)
                        .foregroundColor(.black)
            }

            Spacer()

            switch engine.activeCard {

            case .RED_ZERO:
                CardStackView(card: .RED_ZERO)
            case .RED_ONE:
                CardStackView(card: .RED_ONE)
            case .RED_TWO:
                CardStackView(card: .RED_TWO)
            case .RED_THREE:
                CardStackView(card: .RED_THREE)
            case .RED_FOUR:
                CardStackView(card: .RED_FOUR)
            case .RED_FIVE:
                CardStackView(card: .RED_FIVE)
            case .RED_SIX:
                CardStackView(card: .RED_SIX)
            case .RED_SEVEN:
                CardStackView(card: .RED_SEVEN)
            case .RED_EIGHT:
                CardStackView(card: .RED_EIGHT)
            case .RED_NINE:
                CardStackView(card: .RED_NINE)
            case .BLUE_ZERO:
                CardStackView(card: .BLUE_ZERO)
            case .BLUE_ONE:
                CardStackView(card: .BLUE_ONE)
            case .BLUE_TWO:
                CardStackView(card: .BLUE_TWO)
            case .BLUE_THREE:
                CardStackView(card: .BLUE_THREE)
            case .BLUE_FOUR:
                CardStackView(card: .BLUE_FOUR)
            case .BLUE_FIVE:
                CardStackView(card: .BLUE_FIVE)
            case .BLUE_SIX:
                CardStackView(card: .BLUE_SIX)
            case .BLUE_SEVEN:
                CardStackView(card: .BLUE_SEVEN)
            case .BLUE_EIGHT:
                CardStackView(card: .BLUE_EIGHT)
            case .BLUE_NINE:
                CardStackView(card: .BLUE_NINE)
            case .GREEN_ZERO:
                CardStackView(card: .GREEN_ZERO)
            case .GREEN_ONE:
                CardStackView(card: .GREEN_ONE)
            case .GREEN_TWO:
                CardStackView(card: .BLUE_TWO)
            case .GREEN_THREE:
                CardStackView(card: .GREEN_THREE)
            case .GREEN_FOUR:
                CardStackView(card: .GREEN_FOUR)
            case .GREEN_FIVE:
                CardStackView(card: .GREEN_FIVE)
            case .GREEN_SIX:
                CardStackView(card: .GREEN_SIX)
            case .GREEN_SEVEN:
                CardStackView(card: .GREEN_SEVEN)
            case .GREEN_EIGHT:
                CardStackView(card: .GREEN_EIGHT)
            case .GREEN_NINE:
                CardStackView(card: .GREEN_NINE)
            case .YELLOW_ZERO:
                CardStackView(card: .YELLOW_ZERO)
            case .YELLOW_ONE:
                CardStackView(card: .YELLOW_ONE)
            case .YELLOW_TWO:
                CardStackView(card: .YELLOW_TWO)
            case .YELLOW_THREE:
                CardStackView(card: .YELLOW_THREE)
            case .YELLOW_FOUR:
                CardStackView(card: .YELLOW_FOUR)
            case .YELLOW_FIVE:
                CardStackView(card: .YELLOW_FIVE)
            case .YELLOW_SIX:
                CardStackView(card: .YELLOW_SIX)
            case .YELLOW_SEVEN:
                CardStackView(card: .YELLOW_SEVEN)
            case .YELLOW_EIGHT:
                CardStackView(card: .YELLOW_EIGHT)
            case .YELLOW_NINE:
                CardStackView(card: .YELLOW_NINE)
            case .CHOOSE:
                CardStackView(card: .CHOOSE)


            case .Y_CHOOSE:
                CardStackView(card: .Y_CHOOSE)
            case .G_CHOOSE:
                CardStackView(card: .G_CHOOSE)

            case .R_CHOOSE:
                CardStackView(card: .R_CHOOSE)

            case .B_CHOOSE:
                CardStackView(card: .B_CHOOSE)

            }

            Spacer()


        }

    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView().environmentObject(MP_Session())
    }
}
