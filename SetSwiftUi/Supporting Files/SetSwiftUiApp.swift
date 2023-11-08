//
//  SetSwiftUiApp.swift
//  SetSwiftUi
//
//  Created by sam hastings on 02/11/2023.
//

import SwiftUI

@main
struct SetSwiftUiApp: App {
    @State var setGameViewModel = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(setGameViewModel: setGameViewModel)
        }
    }
}
