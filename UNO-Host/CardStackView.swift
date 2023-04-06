//
//  CardStackView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 26.01.23.
//

import SwiftUI

struct CardStackView: View {

    var card: Cards
    var rotationDegree: Int
    let animationCard: Bool

    @State var scale: Double = 1

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(card.rawValue).resizable().frame(maxWidth: 350, maxHeight: 600)
                        .rotationEffect(Angle(degrees: Double(rotationDegree)))
                Spacer()
            }
            Spacer()
        }
                .onAppear() {
                    if animationCard {
                        self.scale = 1.5
                        withAnimation(.easeInOut(duration: 0.35)) {
                            self.scale -= 0.5
                        }
                    }
                }
                .scaleEffect(CGFloat(scale))

    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView(card: .RED_ZERO, rotationDegree: 90, animationCard: true)
    }
}
