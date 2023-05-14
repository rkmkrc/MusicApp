//
//  FavoriteTrack+CoreDataProperties.swift
//  MusicApp
//
//  Created by Erkam Karaca on 14.05.2023.
//
//

import Foundation
import CoreData


extension FavoriteTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTrack> {
        return NSFetchRequest<FavoriteTrack>(entityName: "FavoriteTrack")
    }

    @NSManaged public var duration: Int64
    @NSManaged public var id: Int64
    @NSManaged public var preview: String?
    @NSManaged public var title: String?
    @NSManaged public var pictureLink: String?

}

extension FavoriteTrack : Identifiable {

}
