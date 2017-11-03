//
//  GIFObjectsShowModels.swift
//  GiphyAppDemo
//
//  Created by msm72 on 02.11.2017.
//  Copyright (c) 2017 RemoteJob. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Data models
enum GIFObjectsShowModels {
    // MARK: - Use cases
    enum FetchGIFObjects {
        struct RequestModel {
            let parameterQ: String?
            let parameterOffset: Int
        }
        
        struct ResponseModel {
        }
        
        struct ViewModel {
        }
    }
}
