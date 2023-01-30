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

    @State var username: String = UIDevice.current.name

    var body: some View {
        VStack {
            Text("Willkommen zu UNO-Experience!")
            Text("Starte das Spiel auf dem Host-Gerät")
            Spacer().frame(maxHeight: 50)
            HStack(spacing: 20) {
                Spacer().frame(maxWidth: 25)
                Button("Verbinden") {
                    sessionHandler.goOnline(username: username)
                }.buttonStyle(.bordered)
                TextField("Username", text: $username)
                Spacer().frame(maxWidth: 25)

            }
            Spacer().frame(maxHeight: 50)
            Text("Verbundene Geräte \(sessionHandler.connectedPeers.count):")
            Text(String(describing: sessionHandler.connectedPeers.map(\.displayName)))


            Spacer().frame(maxHeight: 100)
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView().environmentObject(MP_Session())
    }
}

