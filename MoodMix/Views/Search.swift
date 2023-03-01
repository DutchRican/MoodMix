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
                HStack {
                    TextField("Search for an album, artist or song", text: $debouncedObject.text)
                        .onChange(of: debouncedObject.debouncedText) { text in
                            
                            musicSuggestions.loadSuggestions(for: text)
                            
                        }
                        .font(.system(size: 12, weight: .medium))
                    
                        .focused($focusState)
                    Image(systemName: "delete.left")
                        .opacity(debouncedObject.text.count > 0 ? 1 : 0.3)
                        .onTapGesture {
                            self.debouncedObject.text = ""
                            musicSuggestions.suggestions = []
                            aiSuggestions.submittedRequest = false
                        }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(UIColor.lightGray), lineWidth: 1)
                )
                Button("Get Suggestions"){
                    Task {
                        aiSuggestions.resetAll()
                        await aiSuggestions.sendRequest(for: selectedItem!)
                        aiSuggestions.getAiSuggestions()
                        selectedItem = nil
                    }
                }
                .opacity((!aiSuggestions.submittedRequest && selectedItem == nil) ? 0.5 : 1.0)
                .disabled(aiSuggestions.submittedRequest || selectedItem == nil)
//                Spacer()
                
                if !musicSuggestions.suggestions.isEmpty {
                    List(musicSuggestions.suggestions, id: \.self) { sug in
                        Text("\(sug.title ?? "") - \(sug.artistCredit?.first?.artist?.name ?? "")")
                            .font(.system(size: 14, weight: .regular))
                            .onTapGesture {
                                selectedItem = sug
                                debouncedObject.preventAfterSelect = true
                                debouncedObject.text = "\(sug.title ?? "") - \(sug.artistCredit?.first?.artist?.name ?? "")"
                                musicSuggestions.suggestions = []
                                focusState = false
                            }
                    }
                    .zIndex(99)
                    .frame(minHeight: 300)
                }
            }
        }
    }
}

struct Search_Previews: PreviewProvider {
    @StateObject static var musicSuggestion = MusicSuggestions()
    
    static var previews: some View {
        musicSuggestion.suggestions = [Release(id: "sdfsf2342", score: 2, title: "test-title", status: "testStatus", artistCredit: [ArtistCredit(name: "test-artist", artist: ArtistName(name: "queen"))])]
        return Group {
            Search().environmentObject(AiSuggestions())
            Search(musicSuggestions: musicSuggestion).environmentObject(AiSuggestions())
            
        }
    }
}
