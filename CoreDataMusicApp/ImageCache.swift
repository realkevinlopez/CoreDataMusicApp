//
//  ImageCache.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import Foundation

final class ImageCache {
    static let shared = ImageCache()
    private var cache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()
    private init() { }
}

extension ImageCache {
    
    func getImageData(key: String) -> Data? {
        let nsKey = NSString(string: key)
        guard let object = self.cache.object(forKey: nsKey) else { return nil }
        return Data(referencing: object)
    }
    
    func setImageData(key: String, data: Data) {
        let nsKey = NSString(string: key)
        let object = NSData(data: data)
        self.cache.setObject(object, forKey: nsKey)
    }
    
}
