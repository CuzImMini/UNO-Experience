//
//  DeckView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct DeckView: View {
    
    @EnvironmentObject var engine: MP_Session

    var body: some View {
        VStack() {
            Text("Hier kommen UNO Karten!")
            Button("Rot 0") {
                engine.sendTraffic(data: Cards.RED_ZERO.rawValue.data(using: .isoLatin1)!)
            }
            Button("Rot-1") {
                engine.sendTraffic(data: Cards.RED_ONE.rawValue.data(using: .isoLatin1)!)

            }
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
