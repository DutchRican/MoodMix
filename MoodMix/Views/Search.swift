//
//  Search.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import SwiftUI

struct Search: View {
    @StateObject var debouncedObject = DebouncedTextField()
    @StateObject var musicSuggestions = MusicSuggestions()
    @EnvironmentObject var aiSuggestions: AiSuggestions
    @State private var selectedItem: Release?
    @FocusState private var focusState: Bool
    
    var body: some View {
        VStack {
            VStack {
                TextField("Search for an album, artist or song", text: $debouncedObject.text)
                    .onChange(of: debouncedObject.debouncedText) { text in
                        
                        musicSuggestions.loadSuggestions(for: text)}
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 12, weight: .medium))
                    .padding()
                    .focused($focusState)
                
               
            }
            HStack{
                if !musicSuggestions.suggestions.isEmpty {
                    List(musicSuggestions.suggestions, id: \.self) { sug in
                        ZStack {
                            Text("\(sug.title ?? "") - \(sug.artistCredit?.first?.artist?.name ?? "")")
                                .font(.system(size: 14, weight: .regular))
                        }
                        .onTapGesture {
                            selectedItem = sug
                            debouncedObject.preventAfterSelect = true
                            debouncedObject.text = "\(sug.title ?? "") - \(sug.artistCredit?.first?.artist?.name ?? "")"
                            musicSuggestions.suggestions = []
                            focusState = false
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .zIndex(1)
                    .frame(minHeight: 200)
                }
                if selectedItem != nil {
                    Button("Get Suggestions"){
                        Task {
                            aiSuggestions.resetAll()
                            await aiSuggestions.sendRequest(for: selectedItem!)
                            aiSuggestions.getAiSuggestions()
                        }
                        
                    }
                }
            }
            Spacer()
        }
        .frame(maxHeight: musicSuggestions.suggestions.isEmpty ? 100 : 300)
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
