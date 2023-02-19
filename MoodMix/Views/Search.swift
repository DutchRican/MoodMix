//
//  Search.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import SwiftUI

struct Search: View {
    @State var searchInput: String = ""
    
    private var suggestions = ["One", "Two", "Three", "and more"]
    
    var body: some View {
        VStack {
            TextField("", text: $searchInput)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        List(suggestions, id: \.self) { sug in
            ZStack {
                Text(sug)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
