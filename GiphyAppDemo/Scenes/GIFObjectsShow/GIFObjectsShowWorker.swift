//
//  GIFObjectsShowWorker.swift
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

class GIFObjectsShowWorker {
    // MARK: - Business Logic
    func createURL(withParameterQ parameterQ: String?, andParameterOffset parameterOffset: Int) -> URL {
        let components = NSURLComponents()
        components.scheme = "http"
        components.host = "api.giphy.com"
        components.path = "/v1/gifs/search"

        let itemQ       =   URLQueryItem(name: "q", value: parameterQ)
        let itemLimit   =   URLQueryItem(name: "limit", value: "\(paginationLimit)")
        let itemOffset  =   URLQueryItem(name: "offset", value: "\(parameterOffset)")
        let itemKeyAPI  =   URLQueryItem(name: "api_key", value: "ENGmeWFYfqEeCO7iCKKt0MIvPBcSd9Rm")
        
        components.queryItems = [itemQ, itemLimit, itemOffset, itemKeyAPI]

        return components.url!
    }

    func fetchGIFObjects(witURL url: URL, completionHandler: @escaping (ResponseObject?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject.self, from: data!)
                completionHandler(responseObject)
            } catch {
                completionHandler(nil)
            }
        }).resume()
    }
}

