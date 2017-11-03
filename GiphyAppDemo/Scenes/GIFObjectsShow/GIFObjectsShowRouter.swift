//
//  GIFObjectsShowRouter.swift
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

// MARK: - Input & Output protocols
@objc protocol GIFObjectsShowRoutingLogic {
    func routeToGIFObjectShow()
}

protocol GIFObjectsShowDataPassing {
    var dataStore: GIFObjectsShowDataStore? { get }
}

class GIFObjectsShowRouter: NSObject, GIFObjectsShowRoutingLogic, GIFObjectsShowDataPassing {
    // MARK: - Properties
    weak var viewController: GIFObjectsShowViewController?
    var dataStore: GIFObjectsShowDataStore?
    
    
    // MARK: - Routing
    func routeToGIFObjectShow() {
        let storyboard = UIStoryboard(name: "GIFObjectShow", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "GIFObjectShowVC") as! GIFObjectShowViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToGIFObjectShow(source: dataStore!, destination: &destinationDS)
        navigateToIFObjectShow(source: viewController!, destination: destinationVC)
    }
    
    
    // MARK: - Navigation
    func navigateToIFObjectShow(source: GIFObjectsShowViewController, destination: GIFObjectShowViewController) {
        source.show(destination, sender: nil)
    }
    
    
    // MARK: - Passing data
    func passDataToGIFObjectShow(source: GIFObjectsShowDataStore, destination: inout GIFObjectShowDataStore) {
        let selectedRow = (viewController?.collectionView.indexPathsForSelectedItems![0])!.row
        destination.objectGIF = source.objectsGIF?[selectedRow]
    }
}