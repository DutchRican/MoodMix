//
//  aiSuggestions.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import Foundation
import Combine

let max_tries = 20

extension HTTPURLResponse {
    func isResponseOK() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}


public class AiSuggestions: ObservableObject {
    @Published var submittedRequest: Bool = false
    @Published var tryCount: Int = 0
    @Published var recommendations: Recommendations?
    @Published var error: String?
    @Published var hasError: Bool = false
    @Published var isChecking: Bool = false
    private var uuid: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func sendRequest(for release: Release) async {
        guard let url = aiUrl() else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            uuid = UUID().uuidString.lowercased()
            let data = """
            { "artist": "\(release.artistCredit!.first!.artist!.name!)",
    "album": "\(release.title!)",
    "requestId": "\(self.uuid!)"}
    """.data(using: .utf8)
            let (_, response) = try await URLSession.shared.upload(for: urlRequest, from: data!)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.isResponseOK() else {
                self.submittedRequest = false;
                return
            }
            DispatchQueue.main.async {
                self.submittedRequest = true
            }
        } catch {
            DispatchQueue.main.async {
                print(error.localizedDescription)
                self.submittedRequest = false
            }
        }
    }
    
    func resetAll() {
        for item in self.cancellables {
            item.cancel()
        }
        self.submittedRequest = false
        self.tryCount = 0
        self.recommendations = nil
        self.error = nil
        self.hasError = false
    }
    
    func getAiSuggestions() {
        guard let url = URL(string: "https://nncpbogydkmgdcxdozla.supabase.co/rest/v1/recommendations?select=*&requestId=eq.\(self.uuid!)") else {return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("en-US,en;q=0.5", forHTTPHeaderField: "Accept-Language")
        request.addValue("public", forHTTPHeaderField: "accept-profile")
        request.addValue("@supabase/auth-helpers-sveltekit@0.8.7", forHTTPHeaderField: "x-client-info")
        request.addValue("empty", forHTTPHeaderField: "Sec-Fetch-Dest")
        request.addValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
        request.addValue("cross-site", forHTTPHeaderField: "Sec-Fetch-Site")
        request.addValue(apikey, forHTTPHeaderField: "apikey")
        request.addValue("Authorization", forHTTPHeaderField: "Bearer \(apikey)")
        
        session.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap {data, response -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.isResponseOK() else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Suggestions].self, decoder: JSONDecoder())
            .sink { _ in } receiveValue: { [weak self] suggestion in
                guard let self = self else {return }
                if suggestion.isEmpty {
                    if self.tryCount >= max_tries {
                        for item in self.cancellables {
                            item.cancel()
                        }
                        self.tryCount = 0
                        self.error = "Could not get suggestions within \(max_tries * 3) seconds"
                        self.hasError = true
                        self.submittedRequest = false
                        return
                    }
                    self.tryCount += 1
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(3), execute: {
                        self.getAiSuggestions()
                    })
                } else {
                    self.recommendations = suggestion.first?.recommendations
                    suggestion.first?.recommendations?.films.forEach { self.getImageUrl(for: "films", with: $0) }
                    suggestion.first?.recommendations?.series.forEach { self.getImageUrl(for: "series", with: $0) }
                    suggestion.first?.recommendations?.albums.forEach { self.getImageUrl(for: "albums", with: $0) }
                    self.submittedRequest = false
                    self.tryCount = 0
                }
            }
            .store(in: &cancellables)
    }
    
    func valueBuilder(_ entity: String, _ item: any SuggestionItem) -> String {
        var alteredEntity = entity
        if alteredEntity == "films" { alteredEntity = "film"}
        var owner = ""
        switch entity {
        case "series":
            owner = "creators"
            break
        case "films":
            owner = "directors"
            break
        default:
            break
        }
        return """
        [{"\(alteredEntity)":"\(item.title ?? "")", "\(owner)": "\(item.owner ?? "")", "\(alteredEntity)_description": "\(item.description ?? "")"}]
        """
    }
    
    func getImageUrl<T>(for entity: String, with data: T ) {
        let item = data as! any SuggestionItem
        let val = valueBuilder(entity, item)
        var components = URLComponents()
        components.scheme = "https"
        components.host = "moodmix.app"
        components.path = "/api/\(entity == "series" ? "tv" : entity)"
        components.queryItems = [
            URLQueryItem(name: "\(entity)", value: val),
        ]
        guard let url = URL(string: components.string!) else {return}
        let session = URLSession.shared
        
        session.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap {data, response -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.isResponseOK() else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [ImageUrl].self, decoder: JSONDecoder())
            .sink { _ in } receiveValue: { [weak self] images in
                guard let self = self else {return }
                switch entity {
                case "films":
                    self.recommendations?.films =  self.recommendations?.films.map { orig in
                        if orig.title == item.title {
                            return Films(title: orig.title, owner: orig.owner, description: orig.description, imageUrl: images.first?.posterPathMedium)
                        }
                        return orig
                    } ?? []
                    break;
                case "series":
                    self.recommendations?.series =  self.recommendations?.series.map { orig in
                        if orig.title == item.title {
                            return Series(title: orig.title, owner: orig.owner, description: orig.description, imageUrl: images.first?.poster_path)
                        }
                        return orig
                    } ?? []
                default:
                    break
                }
                
            }
            .store(in: &cancellables)
        
    }
}
