//
//  ResponseObject.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

struct ResponseObject: Decodable {
    let data: [GIFObject]
    let meta: MetaObject
    let pagination: Pagination
}
