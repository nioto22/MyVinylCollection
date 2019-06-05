//
//  Album+CoreDataProperties.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 05/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var albumName: String?
    @NSManaged public var artistsId: String?
    @NSManaged public var artistsName: String?
    @NSManaged public var dateAdded: String?
    @NSManaged public var formatsName: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var imageSmall: String?
    @NSManaged public var labelName: String?
    @NSManaged public var tracksURL: String?
    @NSManaged public var year: String?

}
