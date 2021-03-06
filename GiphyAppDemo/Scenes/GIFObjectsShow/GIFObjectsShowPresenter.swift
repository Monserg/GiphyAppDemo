//
//  GIFObjectsShowPresenter.swift
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

// MARK: - Presentation Logic protocols
protocol GIFObjectsShowPresentationLogic {
    func presentObjectsGIF(fromResponseModel responseModel: GIFObjectsShowModels.LoadObjectsGIF.ResponseModel)
    func presentGIFObjects(fromResponseModel responseModel: GIFObjectsShowModels.FetchGIFObjects.ResponseModel)
}

class GIFObjectsShowPresenter: GIFObjectsShowPresentationLogic {
    // MARK: - Properties
    weak var viewController: GIFObjectsShowDisplayLogic?
    
    // Dependency Injection
    let coreDataManager: CoreDataManager
    
    
    // MARK: - Class Initialization
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    

    // MARK: - Presentation Logic implementation
    func presentObjectsGIF(fromResponseModel responseModel: GIFObjectsShowModels.LoadObjectsGIF.ResponseModel) {
        // CoreData CRUD: read
        var objectsGIF = coreDataManager.entitiesRead(withPredicateParameters: nil)
        let countMax: Int32 = Int32((objectsGIF?.count)!)
        
        if objectsGIF != nil {
            objectsGIF = Array(objectsGIF!.prefix(responseModel.objectsCount + paginationLimit))
        }
        
        let viewModel = GIFObjectsShowModels.LoadObjectsGIF.ViewModel(countMax: countMax, displayedGIFObjects: objectsGIF)
        viewController?.displayLoadObjectsGIF(fromViewModel: viewModel)
    }

    func presentGIFObjects(fromResponseModel responseModel: GIFObjectsShowModels.FetchGIFObjects.ResponseModel) {
        var predicate: NSPredicate?

        for objectGIF in responseModel.responseObject.data {
            let object = GIFObjectsShowModels.FetchGIFObjects.ViewModel.DisplayedGIFObject.init(id: objectGIF.id,
                                                                                                username: objectGIF.username,
                                                                                                url: objectGIF.url,
                                                                                                fixed_width: (objectGIF.images.fixed_width?.url)!,
                                                                                                fixed_width_small_still: (objectGIF.images.fixed_width_small_still?.url)!,
                                                                                                preview: (objectGIF.images.preview?.mp4)!,
                                                                                                slug: objectGIF.slug,
                                                                                                searchText: responseModel.searchText!)
            
            // CoreData CRUD: update
            coreDataManager.entityUpdate(fromGIFObject: object)
        }

        coreDataManager.contextSave()
        
        // CoreData CRUD: read
        predicate = NSPredicate(format: "searchText == %@", responseModel.searchText!)        
        let objectsGIF = coreDataManager.entitiesRead(withPredicateParameters: predicate)
        
        let viewModel = GIFObjectsShowModels.FetchGIFObjects.ViewModel(countMax: responseModel.countMax, displayedGIFObjects: objectsGIF)
        viewController?.displayFetchGIFObjects(fromViewModel: viewModel)
    }
}
