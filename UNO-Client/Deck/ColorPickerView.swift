//
// Created by Paul Cornelissen on 26.01.23.
//

import Foundation
import SwiftUI

struct ColorPickerView: View {

    @EnvironmentObject var engine: MP_Session
    var card: CardView
    @Binding var showColorPicker: Bool

    var body: some View {

        VStack(spacing: 50) {
            Text("Color Picker")
            HStack(spacing: 50) {
                Button("Rot") {
                    colorPickHandler(card: .R_CHOOSE)
                }
                        .buttonStyle(.bordered)
                        .foregroundColor(Cards.R_CHOOSE.color)
                Button("Blau") {
                    colorPickHandler(card: .B_CHOOSE)
                }
                        .buttonStyle(.bordered)
                        .foregroundColor(Cards.B_CHOOSE.color)


            }
            HStack(spacing: 50) {
                Button("Grün") {
                    colorPickHandler(card: .G_CHOOSE)

                }
                        .buttonStyle(.bordered)
                        .foregroundColor(Cards.G_CHOOSE.color)
                Button("Gelb") {
                    colorPickHandler(card: .Y_CHOOSE)
                }
                        .buttonStyle(.bordered)
                        .foregroundColor(Cards.Y_CHOOSE.color)

            }

        }

    }

    func colorPickHandler(card: Cards) {
        engine.sendTraffic(data: card.rawValue.data(using: .isoLatin1)!)

        engine.hasPlayed = true
        showColorPicker = false
    }


}