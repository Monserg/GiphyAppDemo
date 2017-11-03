//
//  Connectivity.swift
//  GiphyAppDemo
//
//  Created by msm72 on 03.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isNetworkAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
