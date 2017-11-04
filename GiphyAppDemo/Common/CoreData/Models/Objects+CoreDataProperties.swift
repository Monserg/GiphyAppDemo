//
//  Objects+CoreDataProperties.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//
//

import Foundation
import CoreData


extension Objects {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Objects> {
        return NSFetchRequest<Objects>(entityName: "Objects")
    }

    @NSManaged public var data: NSData?

}
