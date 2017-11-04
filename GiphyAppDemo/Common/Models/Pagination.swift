//
//  Pagination.swift
//  GiphyAppDemo
//
//  Created by msm72 on 04.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

struct Pagination: Decodable {
    let count: Int32
    let offset: Int32
    let total_count: Int32
}
