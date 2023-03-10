//
//  ConnectionView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct ConnectionView: View {

    @EnvironmentObject var engine: MP_Session


    var body: some View {
        VStack {
            Text("Willkommen zu UNO-Experience!")
            Text("Zum Starten des Spiels müssen genau zwei Geräte verbunden sein.")
            Spacer().frame(maxHeight: 50)
            Text("Verbundene Geräte \(engine.connectedPeers.count)")
            Text(String(describing: engine.connectedPeers.map(\.displayName)))
            Spacer().frame(maxHeight: 100)

            if engine.isReady {
                Button("Start") {
                    engine.gameHandler.startGameEverywhere()
                }
                        .buttonStyle(.bordered)
            }

        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
