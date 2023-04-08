//
//  HostGameEndView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 07.04.23.
//

import SwiftUI

struct HostGameEndView: View {
    
    @EnvironmentObject var sessionHandler: HostSessionManager
    
    var opponentName: String

    var body: some View {
        
        VStack {
            //Zurück-Knopf
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
                Text("\(opponentName) hat gewonnen!").foregroundColor(.white).font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                Spacer()
            }
            Button("Starte ein neues Spiel") {
                sessionHandler.gameHandler.restartGame()
            } .buttonStyle(.borderedProminent).tint(.blue).padding(.top, 50)
            Spacer()
        }.background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.9, green: 0, blue: 0), Color(red: 0, green: 0, blue: 0.9)]), startPoint: .leading, endPoint: .trailing)
        )
        .toolbar(.hidden, for: .automatic)
    }
}

struct HostGameEndView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameEndView(opponentName: "Paul").environmentObject(HostSessionManager())
    }
}
