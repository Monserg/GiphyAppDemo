//
//  UserObject.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

struct UserObject: Decodable {
    // MARK: - Properties
    let avatar_url: String?
    let banner_url: String?
    let profile_url: String?
    let username: String?
    let display_name: String?
    let twitter: String?
}
