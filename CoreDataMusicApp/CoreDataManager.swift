//
//  CoreDataManager.swift
//  CoreDataMusicApp
//
//  Created by Consultant on 6/1/22.
//

import UIKit
import CoreData

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TopFavs")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Something went wrong, \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error Saving: \(error)")
            }
        }
    }
    
    func makeFavorite(albumFavorited: Album) -> Favorited? {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorited", in: context) else { return nil }
        let favorited = Favorited(entity: entity, insertInto: context)
        favorited.albumName = albumFavorited.name
        favorited.artistName = albumFavorited.artistName
        favorited.buttonStatus = Int16(albumFavorited.fav ?? 0)
        
        return favorited
    }
    
    func deleteFavorite(_ deletedAlbum: Favorited) {
        let context = self.persistentContainer.viewContext
        context.delete(deletedAlbum)
        self.saveContext()
    }
    
    func allAlbumNames() -> [String] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        do {
            let albums = try context.fetch(request)
            return albums.map({$0.albumName ?? ""})
        } catch {
            print("Unable to Fetch  (\(error))")
        }
        return [""]
    }
    
    func allArtistNames() -> [String] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        do {
            let albums = try context.fetch(request)
            return albums.map({$0.artistName ?? ""})
        } catch {
            print("Unable to Fetch (\(error))")
        }
        return [""]
    }
    
    func allButtonStatus() -> [Int] {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        do {
            let albums = try context.fetch(request)
            return albums.map({Int($0.buttonStatus)})
        } catch {
            print("Unable to Fetch Saved Albums, (\(error))")
        }
        return []
    }
    
    func fetchFavorite() -> Favorited? {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let favorited = results.first {
                return favorited
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchTest() -> String? {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let favorited = results[2].artistName {
                return favorited
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func getFavoriteCount() -> Int?{
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
            let albums = try context.fetch(request)
            return albums.map({Int($0.buttonStatus)}).count
        } catch {
            print("Unable to Fetch Saved Albums, (\(error))")
        }
        return 0
    }
    
    func removeFavorite(name: String){
        
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            for index in 0...results.count - 1 {
                if name == "Artist: " + (results[index].artistName ?? "") {
                    let favorited = results[index]
                    print ("Removing \(favorited.artistName ?? "") from favorites")
                    context.delete(favorited)
                    self.saveContext()
                }
            }
        } catch {
            print(error)
        }
    }
    
}
