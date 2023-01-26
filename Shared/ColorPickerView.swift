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

        VStack {
            Text("Color Picker")
            HStack {
                Button("Rot") {
                    engine.sendTraffic(data: Cards.R_CHOOSE.rawValue.data(using: .isoLatin1)!)
                    card.visible = false
                    card.card.visible = false
                    engine.hasPlayed = true

                    showColorPicker = false
                }
                Button("Blau") {
                    engine.sendTraffic(data: Cards.B_CHOOSE.rawValue.data(using: .isoLatin1)!)
                    card.visible = false
                    card.card.visible = false
                    engine.hasPlayed = true

                    showColorPicker = false

                }

            }
            HStack {
                Button("Grün") {
                    engine.sendTraffic(data: Cards.G_CHOOSE.rawValue.data(using: .isoLatin1)!)
                    card.visible = false
                    card.card.visible = false
                    engine.hasPlayed = true

                    showColorPicker = false

                }
                Button("Gelb") {
                    engine.sendTraffic(data: Cards.Y_CHOOSE.rawValue.data(using: .isoLatin1)!)
                    card.visible = false
                    card.card.visible = false
                    engine.hasPlayed = true

                    showColorPicker = false
                }
            }

        }

    }


}