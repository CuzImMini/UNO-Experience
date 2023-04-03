//
//  ConnectionView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct ConnectionView: View {

    @EnvironmentObject var engine: MP_Session

    @State var background: Color = Color.white
    @State var textColor: Color = Color.black


    var body: some View {
        HStack {
            Spacer()

            VStack {
                Spacer()
                Text("Willkommen zu UNO-Experience!")
                Text("Zum Starten des Spiels müssen genau zwei Geräte verbunden sein.")
                Spacer()
                        .frame(maxHeight: 50)
                Text("Verbundene Geräte \(engine.connectedPeers.count)")
                Text(String(describing: engine.connectedPeers.map(\.displayName)))
                Spacer().frame(maxHeight: 100)

                if engine.isReady {
                    Button("Start") {
                        engine.gameHandler.startGame()

                    }
                            .buttonStyle(.bordered)
                }
                Spacer().onChange(of: engine.isReady) { bool in
                    if engine.isReady {
                        background = .green
                        textColor = .white
                    } else {
                        background = .white
                        textColor = .black
                    }
                }
            }
                    .foregroundColor(textColor)
            Spacer()
        }
                .background(background)
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
