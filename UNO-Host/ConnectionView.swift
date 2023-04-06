//
//  ConnectionView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 21.01.23.
//

import SwiftUI

struct ConnectionView: View {
    
    @EnvironmentObject var sessionHandler: MP_Session
    
    @State var deckSize: Int = 8
    
    @State var background: Color = Color.white
    @State var textColor: Color = Color.black
        
    @State var animate = false
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                Text("Willkommen zu UNO-Experience!")
                Text("Zum Starten des Spiels müssen mindestens zwei Geräte verbunden sein.")
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
                Spacer().onChange(of: sessionHandler.connectedPeers.count) { count in
                    if count > 1 {
                        background = .green
                        textColor = .white
                    } else {
                        background = .white
                        textColor = .black
                    }
                }
                .onAppear() {
                    if sessionHandler.connectedPeers.count > 1 {
                        background = .green
                        textColor = .white
                    } else {
                        background = .white
                        textColor = .black
                    }
                }
            }
            .foregroundColor(textColor)
            Spacer()
        }
        .background(background)
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
            .environmentObject(MP_Session())
    }
}
