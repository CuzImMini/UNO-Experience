//
//  MainMenu.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 19.01.23.
//

import MultipeerConnectivity
import SwiftUI


struct MainMenu: View {

    @StateObject var sesssionHandler = MP_Session()

    var body: some View {

        switch self.sesssionHandler.viewState {

        case .mainMenu:
            ConnectionView().environmentObject(self.sesssionHandler)

        case .inGame:
            ClientDeckView().environmentObject(self.sesssionHandler)

        case .loose:
            Text("Du hast verloren du Opfer")
        case .win:
            Text("Du hast gewonnen wuuuwuuu")
        }

    }
}


struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
