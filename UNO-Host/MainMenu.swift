//
//  MainMenu.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 19.01.23.
//

import MultipeerConnectivity
import SwiftUI

struct MainMenu: View {

    @StateObject var sessionHandler = MP_Session()

    var body: some View {

        switch sessionHandler.viewState {

        case .mainMenu:
            ConnectionView()
                    .environmentObject(sessionHandler)
        case .inGame:
            DeckView()
                    .environmentObject(sessionHandler)
        case .loose, .win:
            VStack(spacing: 50) {
                Text("Das Spiel ist zuende!")
                Button("Neustart") {

                    sessionHandler.gameHandler.restart()

                }
            }
        }


    }
}


struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}

