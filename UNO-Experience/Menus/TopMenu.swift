//
//  TopMenu.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 07.04.23.
//

import SwiftUI

struct TopMenu: View {
    
    @ObservedObject var hostSessionHandler: HostSessionManager = HostSessionManager()
    @ObservedObject var clientSessionHandler: ClientSessionManager = ClientSessionManager()
    
    @State var isHost = true
    
    var body: some View {
        NavigationStack(path: isHost ? $hostSessionHandler.gameHandler.activeViewArray : $clientSessionHandler.gameHandler.activeViewArray) {
            VStack {
                Spacer()
                
                Text("Willkommen zu UNO-Experience!")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                Text("Wähle einen Modus um loszulegen:")
                    .foregroundColor(.white)
                    .underline()
                Spacer().frame(maxHeight: 30)
                HStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Button("Spiel hosten") {
                        isHost = true
                        hostSessionHandler.gameHandler.activeViewArray = [.hostMainMenu]
                    }
                    .foregroundColor(.white)
                    .tint(.init(white: 2))
                    .buttonStyle(.bordered)
                    .font(.system(size: 18))
                    Button("Spiel beitreten") {
                        isHost = false
                        clientSessionHandler.gameHandler.activeViewArray = [.clientMainMenu]
                    }
                    .foregroundColor(.white)
                    .tint(.init(white: 2))
                    .buttonStyle(.bordered)
                    .font(.system(size: 18))
                    
                    Spacer()
                }
                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.9, green: 0, blue: 0), Color(red: 0, green: 0, blue: 0.9)]), startPoint: .leading, endPoint: .trailing)
            )
            .navigationDestination(for: ViewStates.self) {state in
                
                switch state {
                    
                case .hostMainMenu:
                    HostConnectionView().environmentObject(hostSessionHandler)
                case .clientMainMenu:
                    ClientConnectionView().environmentObject(clientSessionHandler)
                case .clientInGame:
                    ClientDeckView().environmentObject(clientSessionHandler)
                case .loose:
                    ClientGameEndView(didWin: false, opponentName: clientSessionHandler.gameHandler.winnerName).environmentObject(clientSessionHandler)
                case .win:
                    ClientGameEndView(didWin: true, opponentName: "").environmentObject(clientSessionHandler)
                case .hostInGame:
                    HostDeckView().environmentObject(hostSessionHandler)
                case .hostGameEnd:
                    HostGameEndView(opponentName: hostSessionHandler.gameHandler.winnerName).environmentObject(hostSessionHandler)
                    
                }
                
            }
        }.tint(.white)
    }
    
}



struct TopMenu_Previews: PreviewProvider {
    static var previews: some View {
        TopMenu()
    }
}
