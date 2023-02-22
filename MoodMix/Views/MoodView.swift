//
//  MoodView.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/21/23.
//

import SwiftUI

struct MoodView: View {
    @EnvironmentObject private var aiSuggestions: AiSuggestions
    var body: some View {
        HStack {
            Text("Mood:").font(.system(size: 14, weight: .heavy))
            Text(aiSuggestions.recommendations!.mood ?? "").font(.subheadline)
        }
    }
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView().environmentObject({ () -> AiSuggestions in
            let aiSuggestions = AiSuggestions()
            aiSuggestions.recommendations = Recommendations(mood: "Testy", films: [], albums: [], series: [])
            return aiSuggestions
        }())
    }
}
