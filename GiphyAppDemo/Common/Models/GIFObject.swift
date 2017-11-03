//
//  GIFObject.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

struct GIFObject: Decodable {
    // MARK: - Properties
    let type: String
    let id: String
    let slug: String
    let url: String
    let bitly_url: String?
    let embed_url: String?
    let username: String?
    let source: String?
    let rating: String?
    let content_url: String?
    let source_tld: String?
    let source_post_url: String?
    let update_datetime: String?
    let create_datetime: String?
    let import_datetime: String?
    let trending_datetime: String?
    
    let user: UserObject?
    let images: ImageObject
}
