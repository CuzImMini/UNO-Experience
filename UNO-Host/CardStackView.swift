//
//  CardStackView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 26.01.23.
//

import SwiftUI

struct CardStackView: View {

    var card: Cards
    var rotationRadian: Double

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(card.rawValue).resizable().frame(maxWidth: 350, maxHeight: 600)
                        .rotationEffect(.radians(rotationRadian))
                Spacer()
            }
            Spacer()
        }

    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView(card: .RED_ZERO, rotationRadian: Double.random(in: 0...6.2))
    }
}
