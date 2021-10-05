//
//  SetGameApp.swift
//  SetGame
//
//  Created by Gael G. on 9/30/21.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = SetGame()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
