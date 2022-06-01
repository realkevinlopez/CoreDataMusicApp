//
//  Model.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

struct Opening: Decodable {
    var feed: Feed
}

struct Feed: Decodable {
    var results: [Album]
}

struct Album: Decodable {
    
    let artistName, id, name, releaseDate: String
    let artistID: String?
    let artistURL: String?
    let genres: [Genre]
    let artworkUrl100: String?
    let url: String
    var fav: Int?
    
    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case artworkUrl100, url, genres, fav
    }
}

struct Genre: Decodable {
    let genreID: String
    let name: Name
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}

enum Name: String, Decodable {
    case alternative = "Alternative"
    case childrenSMusic = "Children's Music"
    case classical = "Classical"
    case country = "Country"
    case dance = "Dance"
    case electronic = "Electronic"
    case hipHopRap = "Hip-Hop/Rap"
    case kPop = "K-Pop"
    case latin = "Latin"
    case music = "Music"
    case pop = "Pop"
    case rBSoul = "R&B/Soul"
    case rock = "Rock"
    case soundtrack = "Soundtrack"
}
