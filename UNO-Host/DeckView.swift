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
        
        /*
                Button("Zurück") {
                    self.engine.gameHandler.changeViewState(viewState: .mainMenu)
                }
                .buttonStyle(.bordered)
            
            */
        
            switch engine.activeCard {
                
            case .RED_ZERO:
                CardView(card: .RED_ZERO)
            case .RED_ONE:
                CardView(card: .RED_ONE)
                /*
            case .RED_ONE:
                <#code#>
            case .RED_TWO:
                <#code#>
            case .RED_THREE:
                <#code#>
            case .RED_FOUR:
                <#code#>
            case .RED_FIVE:
                <#code#>
            case .RED_SIX:
                <#code#>
            case .RED_SEVEN:
                <#code#>
            case .RED_EIGHT:
                <#code#>
            case .RED_NINE:
                <#code#>
            case .BLUE_ZERO:
                <#code#>
            case .BLUE_TWO:
                <#code#>
            case .BLUE_THREE:
                <#code#>
            case .BLUE_FOUR:
                <#code#>
            case .BLUE_FIVE:
                <#code#>
            case .BLUE_SIX:
                <#code#>
            case .BLUE_SEVEN:
                <#code#>
            case .BLUE_EIGHT:
                <#code#>
            case .BLUE_NINE:
                <#code#>
            case .GREEN_ZERO:
                <#code#>
            case .GREEN_ONE:
                <#code#>
            case .GREEN_TWO:
                <#code#>
            case .GREEN_THREE:
                <#code#>
            case .GREEN_FOUR:
                <#code#>
            case .GREEN_FIVE:
                <#code#>
            case .GREEN_SIX:
                <#code#>
            case .GREEN_SEVEN:
                <#code#>
            case .GREEN_EIGHT:
                <#code#>
            case .GREEN_NINE:
                <#code#>
            case .YELLOW_ZERO:
                <#code#>
            case .YELLOW_ONE:
                <#code#>
            case .YELLOW_TWO:
                <#code#>
            case .YELLOW_THREE:
                <#code#>
            case .YELLOW_FOUR:
                <#code#>
            case .YELLOW_FIVE:
                <#code#>
            case .YELLOW_SIX:
                <#code#>
            case .YELLOW_SEVEN:
                <#code#>
            case .YELLOW_EIGHT:
                <#code#>
            case .YELLOW_NINE:
                <#code#>
            case .CHOOSE:
                <#code#>
                 */
            }
            
        
        
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
