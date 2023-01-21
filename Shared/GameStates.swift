//
//  GameStates.swift
//  UNO-Experience
//
//  Created by Paul Cornelissen on 21.01.23.
//

import Foundation

//Diese Enums werden später genutzt um die Kommunikation zwischen den Geräten zu erleichtern

enum ViewStates: String {
    
    case mainMenu = "mainmenu"
    case inGame = "ingame"
    
}

enum GameStates: String {
    
    case running = "running"
    case noGame = "nogame"
    
}
