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
    let animationCard: Bool

    @State var visibility: Double = 1

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
                .onAppear() {
                    if animationCard {
                        self.visibility = 1.5
                        withAnimation(.easeInOut(duration: 0.35)) {
                            self.visibility -= 0.5
                        }
                    }
                }
                .scaleEffect(CGFloat(visibility))

    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView(card: .RED_ZERO, rotationRadian: Double.random(in: 0...6.2), animationCard: true)
    }
}
