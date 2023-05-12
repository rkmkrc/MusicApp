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
    
    func addToFavorites(track: Track) {
        
        if isInFavorites(track: track) {return}
        // Get the managed object context from your Core Data stack
        let context = self.context
        
        // Create a new FavoriteTrack instance
        let favoriteTrack = FavoriteTrack(context: context)
        
        // Set the properties of the entity using the values from the struct
        favoriteTrack.id = Int64(track.id ?? 0)
        favoriteTrack.title = track.title
        favoriteTrack.duration = Int64(track.duration ?? 0)
        favoriteTrack.preview = track.preview
        
        // Save the context to persist the changes
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func getAllFavoriteTracks() -> [FavoriteTrack] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create a fetch request for the FavoriteTrack entity
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
        
        do {
            // Execute the fetch request and retrieve the favorite tracks
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
        
        // Create a fetch request for the FavoriteTrack entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteTrack.fetchRequest()
        
        do {
            // Execute the fetch request to retrieve all favorite tracks
            let favoriteTracks = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            // Delete each favorite track
            for favoriteTrack in favoriteTracks {
                context.delete(favoriteTrack)
            }
            
            // Save the context to persist the deletions
            try context.save()
        } catch {
            print("Error deleting favorite tracks: \(error)")
        }
    }
    
    func isInFavorites(track: Track) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create a fetch request for the FavoriteTrack entity
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
        
        // Set up a predicate to filter by track id
        let predicate = NSPredicate(format: "id == %lld", track.id ?? 0)
        fetchRequest.predicate = predicate
        
        do {
            // Execute the fetch request with the predicate
            let favoriteTracks = try context.fetch(fetchRequest)
            return !favoriteTracks.isEmpty
        } catch {
            print("Error fetching favorite tracks: \(error)")
            return false
        }
    }
    
    func turnTrackToFavoriteTrack(track: Track) -> FavoriteTrack {
        let favoriteTrack = FavoriteTrack()
        
        // Set the properties of the favorite track using the values from the track
        favoriteTrack.id = Int64(track.id ?? 0)
        favoriteTrack.title = track.title
        favoriteTrack.duration = Int64(track.duration ?? 0)
        favoriteTrack.preview = track.preview
        
        return favoriteTrack
    }
    
}
