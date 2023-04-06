//
//  ConnectionView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI
import MultipeerConnectivity

struct ConnectionView: View {

    @EnvironmentObject var sessionHandler: MP_Session

    @State var username: String = "Spieler " + String(Int.random(in: 1...1000))

    @State var backgroundColor: Color = Color(red: 0.9, green: 0, blue: 0)

    var body: some View {
        VStack {
            Spacer()
            Text("Willkommen zu UNO-Experience!").foregroundColor(.white)
            Text("Starte das Spiel auf dem Host-Gerät").foregroundColor(.white)
            Spacer().frame(maxHeight: 50)
            HStack(spacing: 20) {
                Spacer().frame(maxWidth: 25)
                Button("Verbinden") {
                    sessionHandler.goOnline(username: username)

                }
                        .foregroundColor(.white)
                        .buttonStyle(.bordered)

                TextField("Username", text: $username)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())


                Spacer().frame(maxWidth: 25)

            }
            Spacer().frame(maxHeight: 50)
            Text("Verbundene Geräte \(sessionHandler.connectedPeers.count)").foregroundColor(.white)

            Spacer().frame(maxHeight: 100)
            Spacer()
        }
                .background(backgroundColor).onChange(of: sessionHandler.connectedPeers) { peerNumber in
                    if peerNumber.count > 1 {
                        backgroundColor = .green
                    } else {
                        backgroundColor = Color(red: 0.9, green: 0, blue: 0)
                    }

                }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView().environmentObject(MP_Session())
    }
}

