//
//  MoodMixApp.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import SwiftUI

@main
struct MoodMixApp: App {
    @StateObject private var aiSuggestions = AiSuggestions()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(aiSuggestions)
        }
    }
}
