//
//  NetworkParams.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import Foundation

enum NetworkParams {
    case albumList
    case albumImage(path: String)
    
    var url: URL? {
        switch self {
        case .albumList:
            guard let urlComponents = URLComponents(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/100/albums.json") else { return nil }
            
            return urlComponents.url
            
        case .albumImage(path: let path):
            return URL(string: "\(path)")
        }
    }
}
