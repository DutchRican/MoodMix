//
//  Suggestions.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import Foundation

struct Films: Codable {
    var film: String?
    var director: String?
    var filmDescription: String?
}

struct Albums: Codable {
    var  album : String?
    var  artist: String?
    var  albumDescription: String?
}

struct Series: Codable {
    var  series: String?
    var  creators :String?
    var  seriesDescription: String?
}

struct RequestedAlbum: Codable {
    var  album: String?
    var  artist: String?
    var  information: String?
}

struct Recommendations: Codable {
    var mood: String?
    var films: [Films]?
    var albums: [Albums]?
    var series: [Series]?
    var requestedAlbum: RequestedAlbum?
}
