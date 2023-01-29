//
//  CardStackView.swift
//  UNO-Host
//
//  Created by Paul Cornelissen on 26.01.23.
//

import SwiftUI

struct CardStackView: View {

    var card: Cards

    var body: some View {
        Text(card.description).foregroundColor(card.color).font(.system(size: 50))
        //Image(systemName: card.description)
            
    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView(card: .RED_ZERO)
    }
}
