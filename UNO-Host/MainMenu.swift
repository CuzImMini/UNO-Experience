//
//  MainMenu.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 19.01.23.
//

import MultipeerConnectivity
import SwiftUI

struct MainMenu: View {

    @StateObject var engine = MP_Session()

    var body: some View {

        switch self.engine.viewState {

        case .mainMenu:
            ConnectionView()
                    .environmentObject(self.engine)
        case .inGame:
            DeckView()
                    .environmentObject(self.engine)
        case .loose:
            VStack {
                Text("Das Spiel ist zuende!")
                Text("Platzhalter für Neustartknopf")
            }
        case .win:
            VStack {
                Text("Das Spiel ist zuende!")
                Text("Platzhalter für Neustartknopf")
            }
        }


    }
}


struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}

