//
//  ContentView.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var aiSuggestions: AiSuggestions
    
    var body: some View {
        VStack {
            Header()
            Description()
            Search()
            Recommended()
                .frame(maxHeight: .infinity)
//            Spacer()
            
            if aiSuggestions.tryCount > 0 {
                ProgressView("one moment please \(aiSuggestions.tryCount)")
            }
            Spacer()
            Footer()
            
        }
        .padding()
        .alert(aiSuggestions.error ?? "", isPresented: $aiSuggestions.hasError) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AiSuggestions())
    }
}
