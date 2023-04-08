//
//  HostConnectionView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 07.04.23.
//

import SwiftUI

struct HostConnectionView: View {
    
    @EnvironmentObject var sessionHandler: HostSessionManager
    
    @State var deckSize: Int = 8
    
    @State var background: Color = Color("ConnectionColorRed")
    
    @State var hostInGame: Bool = false
    @State var gameEnded: Bool = false
    
    var body: some View {
            VStack() {
                HStack() {
                    HStack() {
                        Image(systemName: "arrow.left")
                        Text("Zurück")
                    }.foregroundColor(.white).padding(.horizontal, 35).padding(.vertical, 10)
                        .onTapGesture {
                            sessionHandler.gameHandler.activeViewArray = []
                            sessionHandler.goOffline()
                        }
                    Spacer()
                    
                }
                Spacer()
                
                VStack {
                    Spacer()
                    Text("Du bist der Host!").padding(.bottom, 50).font(.title)
                    HStack(spacing: 20) {
                        Button("Suche Clients") {
                            if sessionHandler.isOnline {return}
                            sessionHandler.goOnline()
                        }
                        .buttonStyle(.bordered)
                        .tint(.white)
                        Text(sessionHandler.isOnline ? "Status: online" : "Status: offline")
                        if !sessionHandler.isOnline {}
                        else {ProgressView().tint(.white)}
                    }
                    Spacer()
                        .frame(maxHeight: 50)
                    Text("Verbundene Geräte \(sessionHandler.connectedPeers.count)")
                    Text(String(describing: sessionHandler.connectedPeers.map(\.displayName)))
                    Spacer().frame(maxHeight: 100)
                    
                    if sessionHandler.connectedPeers.count > 1 {
                        HStack(spacing: 20) {
                            Spacer()
                            Stepper("Deckgröße: \(deckSize)", value: $deckSize).frame(maxWidth: 300).onChange(of: deckSize) {size in
                                if (size < 1) {
                                    self.deckSize = 1
                                }
                            }
                    
                            Button("Start") {
                                sessionHandler.gameHandler.startGame(deckSize: deckSize)
                                
                            }
                            .buttonStyle(.bordered)
                            Spacer()
                        }
                        
                    }
                    Spacer()
                        .onChange(of: sessionHandler.connectedPeers.count) { count in
                            if count > 1 {
                                background = Color("ConnectionColorGreen")
                            } else {
                                background = Color("ConnectionColorRed")
                            }
                        }
                        .onAppear() {
                            if sessionHandler.connectedPeers.count > 1 {
                                background = Color("ConnectionColorGreen")
                            } else {
                                background = Color("ConnectionColorRed")
                            }
                        }
                        .onDisappear() {
                            sessionHandler.stopConnectionMode()
                            sessionHandler.connectedPeers = []
                        }
                }
                .foregroundColor(.white)
                Spacer()
            }
            .toolbar(.hidden, for: .automatic)
            .background(background)
            
        
    }
}

struct HostConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        HostConnectionView().environmentObject(HostSessionManager())
    }
}
