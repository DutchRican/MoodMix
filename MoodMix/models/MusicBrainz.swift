//
//  MusicBrainz.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import Foundation

struct ArtistName: Codable {
    var name: String?
}
struct ArtistCredit: Codable {
    var name: String?
    var artist: ArtistName?
}


struct Release: Codable, Identifiable, Hashable {
    static func == (lhs: Release, rhs: Release) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String?
    var score: Int?
    var title: String?
    var status: String?
    var artistCredit: [ArtistCredit]?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case score = "score"
        case title = "title"
        case status = "status"
        case artistCredit = "artist-credit"
    }
}

struct Music: Codable {
    var releases: [Release]?
}

func musicUrlFor(query: String) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "musicbrainz.org"
    components.path = "/ws/2/release"
    components.queryItems = [
        URLQueryItem(name: "query", value: query),
        URLQueryItem(name: "fmt", value: "json")
    ]
    return URL(string: components.string!)
}
