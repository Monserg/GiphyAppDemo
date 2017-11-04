//
//  GIFObjectsShowInteractor.swift
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

// MARK: - Business Logic protocols
protocol GIFObjectsShowBusinessLogic {
    func loadObjectsGIF(withRequestModel requestModel: GIFObjectsShowModels.LoadObjectsGIF.RequestModel)
    func fetchGIFObjects(withRequestModel requestModel: GIFObjectsShowModels.FetchGIFObjects.RequestModel)
}

protocol GIFObjectsShowDataStore {
    var objectsGIF: [ObjectGIF]? { get }
}

class GIFObjectsShowInteractor: GIFObjectsShowBusinessLogic, GIFObjectsShowDataStore {
    // MARK: - Properties
    var presenter: GIFObjectsShowPresentationLogic?
    var worker: GIFObjectsShowWorker?

    var objectsGIF: [ObjectGIF]?
    
    
    // MARK: - Business logic implementation
    func loadObjectsGIF(withRequestModel requestModel: GIFObjectsShowModels.LoadObjectsGIF.RequestModel) {
        let responseModel = GIFObjectsShowModels.LoadObjectsGIF.ResponseModel(objectsCount: requestModel.objectsCount)
        presenter?.presentObjectsGIF(fromResponseModel: responseModel)
    }

    func fetchGIFObjects(withRequestModel requestModel: GIFObjectsShowModels.FetchGIFObjects.RequestModel) {
        worker = GIFObjectsShowWorker()
        var parameterQ: String = ""
        let parametersQ = requestModel.parameterQ?.components(separatedBy: CharacterSet.whitespaces).filter({ !$0.isEmpty })
        
        if let words = parametersQ {
            for word in words {
                if parameterQ.count == 0 {
                    parameterQ = word
                } else {
                    parameterQ = parameterQ + "+" + word
                }
            }
        }
        
        let url = worker?.createURL(withParameterQ: parameterQ, andParameterOffset: requestModel.parameterOffset)
        
        worker?.fetchGIFObjects(witURL: url!, completionHandler: { (responseObject) in
            let responseModel = GIFObjectsShowModels.FetchGIFObjects.ResponseModel(countMax: (responseObject?.pagination.total_count)!,
                                                                                   searchText: parameterQ,
                                                                                   responseObject: responseObject!)
            
            self.presenter?.presentGIFObjects(fromResponseModel: responseModel)
        })
    }
}
