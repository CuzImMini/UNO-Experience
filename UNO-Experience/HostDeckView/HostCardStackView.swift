//
//  HostCardStackView.swift
//  UNO-Client
//
//  Created by Paul Cornelissen on 07.04.23.
//

import SwiftUI

struct HostCardStackView: View {
    
    var card: Cards
    var rotationDegree: Int
    let animationCard: Bool
    
    @State var scale: Double = 1
    
    var body: some View {
        //Reader für Bildschirmgröße
        GeometryReader {geo in
        //Stack mit ganzem Inhalt, Stacks zum Zentrieren der Karte
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(card.rawValue).resizable().scaledToFit()
                    .rotationEffect(Angle(degrees: Double(rotationDegree)))
                    .frame(width: geo.size.width, height: geo.size.height/1.5)
            
                Spacer()
            }
            Spacer()
            }
            //Animation
        .onAppear() {
            if animationCard {
                self.scale = 1.5
                withAnimation(.easeInOut(duration: 0.35)) {
                    self.scale -= 0.5
                }
            }
        }
        .scaleEffect(CGFloat(scale))
        }
        
        
    }
}

struct HostCardStackView_Previews: PreviewProvider {
    static var previews: some View {
        HostCardStackView(card: .BFORCESKIP, rotationDegree: 90, animationCard: true)
    }
}
