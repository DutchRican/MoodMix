//
//  MusicBrainz.swift
//  MoodMix
//
//  Created by Paul van Woensel on 2/19/23.
//

import Foundation

struct ArtistCredit: Codable {
    var name: String?
    var artistName: String?
}

struct Release: Codable {
    var id: String?
    var score: Int?
    var title: String?
    var status: String?
    var artisCredit: [ArtistCredit]?
}

struct Music: Codable {
    var releases: [Release]?
}

