//
//  PropertyObject.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

struct PropertyObject: Decodable {
    // MARK: - Properties
    let url: String?
    let width: String?
    let height: String?
    let size: String?
    let mp4: String?
    let mp4_size: String?
    let webp: String?
    let webp_size: String?
    let frames: String?
}
