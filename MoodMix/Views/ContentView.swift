//
//  ContentView.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Description()
            Search()
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
