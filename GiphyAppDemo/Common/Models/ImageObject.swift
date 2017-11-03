//
//  ImageObject.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

struct ImageObject: Decodable {
    // MARK: - Properties
    let fixed_height: PropertyObject?
    let fixed_height_still: PropertyObject?
    let fixed_height_downsampled: PropertyObject?
    let fixed_width: PropertyObject?
    let fixed_width_still: PropertyObject?
    let fixed_width_downsampled: PropertyObject?
    let fixed_height_small: PropertyObject?
    let fixed_height_small_still: PropertyObject?
    let fixed_width_small: PropertyObject?
    let fixed_width_small_still: PropertyObject?
    let downsized: PropertyObject?
    let downsized_still: PropertyObject?
    let downsized_large: PropertyObject?
    let downsized_medium: PropertyObject?
    let downsized_small: PropertyObject?
    let original: PropertyObject?
    let original_still: PropertyObject?
    let looping: PropertyObject?
    let preview: PropertyObject?
    let preview_gif: PropertyObject?
}
