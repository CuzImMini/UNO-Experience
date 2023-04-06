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

        switch sessionHandler.gameHandler.viewState {

        case .mainMenu:
            ConnectionView().environmentObject(sessionHandler)

        case .inGame:
            ClientDeckView().environmentObject(sessionHandler)

        case .loose:
            Text("\(sessionHandler.gameHandler.winnerName!) hat dich besiegt!")
        case .win:
            Text("Du hast gewonnen. Respekt!")
        }

    }
}


struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
