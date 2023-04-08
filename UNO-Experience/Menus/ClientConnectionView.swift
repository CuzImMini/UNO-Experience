//
//  TopConnectionView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 07.04.23.
//

import SwiftUI

struct ClientConnectionView: View {
    
    @EnvironmentObject var sessionHandler: ClientSessionManager
    
    @State var username: String = "Spieler " + String(Int.random(in: 1...1000))
    
    @State var backgroundColor: Color = Color(red: 0.9, green: 0, blue: 0)
        
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        
            VStack {
                //Zurück-Knopf
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
                Text("Du bist ein Spieler!").foregroundColor(.white).padding(.vertical, 25).font(.system(size: 20))
                Text("Wähle einen Namen und klicke Verbinden").foregroundColor(.white)
                Spacer().frame(maxHeight: 20)
                HStack(spacing: 20) {
                    Spacer().frame(maxWidth: 25)
                    Button("Verbinden") {
                        
                        sessionHandler.goOnline(username: username)
                        textFieldIsFocused = false
                    }
                    .keyboardShortcut(.defaultAction)
                    .foregroundColor(.white)
                    .buttonStyle(.bordered)
                    .tint(.white)
                    
                    
                    TextField("Username", text: $username)
                        .autocorrectionDisabled(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                        .focused($textFieldIsFocused)
                    
                    if !sessionHandler.isOnline {
                        Spacer().frame(width: 30, height: 30)}
                    
                    else {
                        ProgressView().tint(.white).frame(width: 30, height: 30)}
                    Spacer().frame(maxWidth: 25)
                    
                }
                Spacer().frame(maxHeight: 75)
                Text("\(sessionHandler.connectedPeers.count) verbundende Geräte").foregroundColor(.white)
                
                Spacer().frame(maxHeight: 100)
                Spacer()
            }
            .tint(.white)
            .toolbar(.hidden, for: .automatic)
            .background(backgroundColor)
            .onChange(of: sessionHandler.connectedPeers) { peerNumber in
                if peerNumber.count > 1 {
                    backgroundColor = Color("ConnectionColorGreen")
                } else {
                    backgroundColor = Color("ConnectionColorRed")
                }
                
            }
    }
}

struct ClientConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ClientConnectionView().environmentObject(ClientSessionManager())
    }
}
