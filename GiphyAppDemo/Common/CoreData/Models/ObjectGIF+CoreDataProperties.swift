//
//  ObjectGIF+CoreDataProperties.swift
//  GiphyAppDemo
//
//  Created by msm72 on 04.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//
//

import Foundation
import CoreData


extension ObjectGIF {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObjectGIF> {
        return NSFetchRequest<ObjectGIF>(entityName: "ObjectGIF")
    }

    @NSManaged public var fixed_width: String?
    @NSManaged public var fixed_width_small_still: String?
    @NSManaged public var id: String
    @NSManaged public var url: String
    @NSManaged public var username: String?
    @NSManaged public var preview: String?
    @NSManaged public var slug: String
    @NSManaged public var searchText: String

}
