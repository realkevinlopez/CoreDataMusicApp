//
//  ViewModel.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import Foundation

@objc protocol AlbumListViewModelType {
    func bind(updateHandler: @escaping () -> Void)
    func getAlbums()
    var  count: Int { get }
    func imageData(index: Int, completion: @escaping (Data?) -> Void)
    func albumTitle(index: Int) -> String?
    func artistName(index: Int) -> String?
    func makeFavorited(index: Int)
    func removeFavorite()
    func albumGenre(index: Int) -> String?
    func dateReleased(index: Int) -> String?
    func buttonStatus(index: Int) -> Int
    func changeButtonStatus(index: Int)
    func removeFavorite(name: String)
    func allAlbumNames() -> [String]
    func allArtistNames() -> [String]
}

class AlbumListViewModel: AlbumListViewModelType {
    private var manager: CoreDataManager
    
    var albums: [Album] {
        didSet {
            self.updateHandler?()
        }
    }
    
    private var favorited: Favorited? {
        didSet {
            self.updateHandler?()
        }
    }
    
    let dataFetcher: DataFetcher
    
    var updateHandler: (() -> Void)?
    
    init(albums: [Album] = [], manager: CoreDataManager = CoreDataManager(), dataFetcher: DataFetcher = NetworkManager()) {
        self.albums = albums
        self.dataFetcher = dataFetcher
        self.manager = manager
    }
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func getAlbums() {
        self.dataFetcher.fetchModel(url: NetworkParams.albumList.url) { [weak self] (result: Result<Opening, Error>) in
            switch result {
            case .success(let page):
                let storedAlbums: [String] = self?.allAlbumNames() ?? []
                var data = page
                var cells: [Int] = []
                if (storedAlbums.count >= 1) {
                    for index in 0...storedAlbums.count - 1 {
                        for count in 0...(page.feed.results.count) - 1 {
                            data.feed.results[count].fav = 0
                            if (storedAlbums[index] == data.feed.results[count].name){
                                cells.append(count)
                            }
                        }
                    }
                }
                
                if (cells.count >= 1){
                    for index in 0...cells.count - 1{
                        data.feed.results[cells[index]].fav = 1
                    }
                }
                
                self?.albums.append(contentsOf: data.feed.results)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var count: Int {
        return self.albums.count
    }
    
    func imageData(index: Int, completion: @escaping (Data?) -> Void) {
        guard index < self.count else {
            completion(nil)
            return
        }
        
        guard let imagePath = self.albums[index].artworkUrl100 else {
            completion(nil)
            return
        }
        
        if let imageData = ImageCache.shared.getImageData(key: imagePath) {
            completion(imageData)
            return
        }
        
        self.dataFetcher.fetchData(url: NetworkParams.albumImage(path: imagePath).url) { result in
            switch result {
            case .success(let data):
                ImageCache.shared.setImageData(key: imagePath, data: data)
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func albumTitle(index: Int) -> String? {
        guard index < self.count else { return nil }
        return "Album: " + self.albums[index].name
    }
    
    func buttonStatus(index: Int) -> Int {
        guard index < self.count else { return 0 }
        if (self.albums[index].fav == nil){
            self.albums[index].fav = 0
        }
        return self.albums[index].fav ?? 5
    }
    
    func changeButtonStatus(index: Int) {
        var x = 0
        if(self.albums[index].fav == 1 && x == 0){
            self.albums[index].fav = 0
            x += 1
        }
        if(self.albums[index].fav == 0 && x == 0){
            self.albums[index].fav = 1}
    }
    
    func artistName(index: Int) -> String? {
        guard index < self.count else { return nil }
        return "Artist: " + self.albums[index].artistName
    }
    
    func dateReleased(index: Int) -> String? {
        guard index < self.count else { return nil }
        return "Date Released: " + self.albums[index].releaseDate
    }
    
    func albumGenre(index: Int) -> String? {
        guard index < self.count else { return nil }
        var genre = ""
        var count = 0
        for i in 0 ..< self.albums[index].genres.count {
            genre.append(self.albums[index].genres[i].name.rawValue)
            count += 1
        }
        return "Genre: \(genre)"
    }
    
    func makeFavorited(index: Int) {
        let favoriteAlbum = self.albums[index]
        self.favorited = self.manager.makeFavorite(albumFavorited: favoriteAlbum)
        print ("Adding \(favoriteAlbum.artistName) to favorites")
        self.manager.saveContext()
    }
    
    func removeFavorite() {
        if let favorited = favorited {
            self.manager.deleteFavorite(favorited)
        }
        self.favorited = nil
    }
    
    func removeFavorite(name: String) {
        self.manager.removeFavorite(name: name)
    }
    
    func allAlbumNames() -> [String]{
        self.manager.allAlbumNames()
    }
    
    func allArtistNames() -> [String]{
        self.manager.allArtistNames()
    }
}
