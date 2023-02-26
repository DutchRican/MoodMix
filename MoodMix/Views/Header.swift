//
//  Header.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/26/23.
//

import SwiftUI

struct Header: View {
    var body: some View {
        HStack {
            Text("MoodMix")
                .font(.custom("AmericanTypewriter", size: 34).weight(.heavy))
        }
        .foregroundColor(Color.purple)
        .padding(.bottom, 5)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
