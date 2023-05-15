//
//  FavoriteManager.swift
//  MusicApp
//
//  Created by Erkam Karaca on 12.05.2023.
//

import Foundation
import CoreData
import UIKit

struct FavoriteManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addToFavorites(track: Track, pictureLink: String?) {
        
        if isInFavorites(track: track) {return}
        let context = self.context
        let favoriteTrack = FavoriteTrack(context: context)
        
        favoriteTrack.id = Int64(track.id ?? 0)
        favoriteTrack.title = track.title
        favoriteTrack.duration = Int64(track.duration ?? 0)
        favoriteTrack.preview = track.preview
        favoriteTrack.pictureLink = pictureLink ?? ""
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func getAllFavoriteTracks() -> [FavoriteTrack] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
        
        do {
            let favoriteTracks = try context.fetch(fetchRequest)
            return favoriteTracks
        } catch {
            print("Error fetching favorite tracks: \(error)")
            return []
        }
    }
    
    func deleteFavoriteTrack(track: Track) {
        if let id = track.id {
            do {
                let favoriteTracks = getAllFavoriteTracks()
                for item in favoriteTracks {
                    if item.id == id {
                        context.delete(item)
                    }
                }
                do {
                    try context.save()
                } catch { print(error) }
            }
        }
    }
    
    func deleteAllFavoriteTracks() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteTrack.fetchRequest()
        
        do {
            let favoriteTracks = try context.fetch(fetchRequest) as! [NSManagedObject]
            for favoriteTrack in favoriteTracks {
                context.delete(favoriteTrack)
            }
            try context.save()
        } catch {
            print("Error deleting favorite tracks: \(error)")
        }
    }
    
    func isInFavorites(track: Track) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
        let predicate = NSPredicate(format: "id == %lld", track.id ?? 0)
        fetchRequest.predicate = predicate
        
        do {
            let favoriteTracks = try context.fetch(fetchRequest)
            return !favoriteTracks.isEmpty
        } catch {
            print("Error fetching favorite tracks: \(error)")
            return false
        }
    }
    
    func fromFavoriteTrackToTrack(favoriteTrack: FavoriteTrack) -> (Track, String) {
        let int64ID: Int64 = favoriteTrack.id
        let intID: Int? = Int(int64ID)
        let int64Dur: Int64 = favoriteTrack.duration
        let intDur: Int? = Int(int64Dur)
        let pictureLink: String? = favoriteTrack.pictureLink
        return (Track(id: intID, title: favoriteTrack.title, duration: intDur, preview: favoriteTrack.preview), pictureLink ?? "")
    }
    
}
