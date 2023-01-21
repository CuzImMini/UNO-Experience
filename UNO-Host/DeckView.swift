//
//  DeckView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct DeckView: View {
    
    @EnvironmentObject var engine: MP_Session
    
    var body: some View {
        Text("Unostapel!")
        Button("Zurück") {
            self.engine.gameHandler.changeViewState(viewState: .mainMenu)
        }
        .buttonStyle(.bordered)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
