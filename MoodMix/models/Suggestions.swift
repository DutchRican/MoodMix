//
//  Suggestions.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import Foundation

protocol SuggestionItem: Identifiable {
    var id: UUID {get}
    var title: String? {get set}
    var owner: String? {get set}
    var description: String? {get set}
    var imageUrl: String? {get set}
}

struct Films: Codable, SuggestionItem {
    let id = UUID()
    var title: String?
    var owner: String?
    var description: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "film"
        case owner = "director"
        case description = "film_description"
    }
}

struct Albums: Codable, SuggestionItem  {
    let id = UUID()
    var title: String?
    var owner: String?
    var description: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "album"
        case owner = "artist"
        case description = "album_description"
    }
}

struct Series: Codable, SuggestionItem  {
    let id = UUID()
    var title: String?
    var owner: String?
    var description: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "series"
        case owner = "creators"
        case description = "series_description"
    }
}

struct RequestedAlbum: Codable {
    var  album: String?
    var  artist: String?
    var  information: String?
}

struct Recommendations: Codable {
    var mood: String?
    var films: [Films]
    var albums: [Albums]
    var series: [Series]
    var requestedAlbum: [RequestedAlbum]?
    
    var lists: [[any SuggestionItem]] {
        let films = self.films.map{ $0 as (any SuggestionItem)}
        let series = self.series.map{ $0 as (any SuggestionItem)}
        let albums = self.albums.map{ $0 as (any SuggestionItem)}
        return [films, series, albums]
    }
}

struct Suggestions: Codable {
    var recommendations: Recommendations?
}

struct ImageUrl: Codable {
    var posterPathMedium: String?
}

func aiUrl() -> URL? {
    return URL(string: apiUrl)
}
