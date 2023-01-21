//
//  ConnectionView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI
import MultipeerConnectivity

struct ConnectionView: View {
    
    @EnvironmentObject var engine: MP_Session
        
    var body: some View {
        VStack {
            Text("Willkommen zu UNO-Experience!")
            Text("Starte das Spiel auf dem Host-Gerät")
            Spacer().frame(maxHeight: 50)
            Text("Verbundene Geräte \(engine.connectedPeers.count):")
            Text(String(describing: engine.connectedPeers.map(\.displayName)))
            
            
            Spacer().frame(maxHeight: 100)
        }    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView().environmentObject(MP_Session())
    }
}

