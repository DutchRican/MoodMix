//
//  musicSuggestions.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import Foundation
import Combine

public class MusicSuggestions: ObservableObject {
    @Published var suggestions: [Release] = []
    private var cancellables = Set<AnyCancellable>()
    
    func loadSuggestions(for query: String) {
        guard let url = musicUrlFor(query: query) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background)) // don't really need this since it is default in BG
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.isResponseOK() else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Music.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] music in
                self?.suggestions = music.releases ?? []
            }
            .store(in: &cancellables)
    }
}
