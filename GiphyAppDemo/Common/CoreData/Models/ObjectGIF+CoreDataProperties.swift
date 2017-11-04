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

    @NSManaged public var id: String?

}
