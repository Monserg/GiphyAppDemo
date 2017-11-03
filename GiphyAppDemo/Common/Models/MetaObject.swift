//
//  MetaObject.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

struct MetaObject: Decodable {
    // MARK: - Properties
    let msg: String
    let status: Int32
    let response_id: String
}
