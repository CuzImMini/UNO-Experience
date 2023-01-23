//
//  CardView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 23.01.23.
//

import SwiftUI

struct CardView: View {
    
    @State var card: Cards
    
    var body: some View {
        Text(card.description)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .RED_ZERO)
    }
}
