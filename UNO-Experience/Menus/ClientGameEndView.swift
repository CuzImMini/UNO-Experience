//
//  HostGameEndView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 07.04.23.
//

import SwiftUI

struct ClientGameEndView: View {
    @EnvironmentObject var sessionHandler: ClientSessionManager

    var didWin: Bool
    var opponentName: String?
    
    var body: some View {
        VStack {
            HStack() {
                HStack() {
                    Image(systemName: "arrow.left")
                    Text("Hauptmenü")
                }.foregroundColor(.white).padding(.horizontal, 35).padding(.vertical, 10)
                    .onTapGesture {
                        sessionHandler.gameHandler.activeViewArray = []
                        sessionHandler.goOffline()
                    }
                Spacer()
                
            }
            Spacer()
            HStack() {
                Spacer()
                Text(didWin ? "Du hast gewonnen!" : "Du wurdest von \(opponentName!) besiegt!").foregroundColor(.white).font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                Spacer()
            }
            Text("Starte auf dem Host ein neues Spiel").foregroundColor(.white).padding(.top, 20)
            Spacer()
        }.background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.9, green: 0, blue: 0), Color(red: 0, green: 0, blue: 0.9)]), startPoint: .leading, endPoint: .trailing)
        )
        .toolbar(.hidden, for: .automatic)
    }
}

struct ClientGameEndView_Previews: PreviewProvider {
    static var previews: some View {
        ClientGameEndView(didWin: false, opponentName: "Paul")
    }
}
