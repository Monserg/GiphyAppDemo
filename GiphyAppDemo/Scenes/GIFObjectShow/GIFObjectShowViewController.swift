//
//  GIFObjectShowViewController.swift
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
protocol GIFObjectShowDisplayLogic: class {
    func displaySomething(viewModel: GIFObjectShowModels.Something.ViewModel)
}

class GIFObjectShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: GIFObjectShowBusinessLogic?
    var router: (NSObjectProtocol & GIFObjectShowRoutingLogic & GIFObjectShowDataPassing)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController  =   self
        let interactor      =   GIFObjectShowInteractor()
        let presenter       =   GIFObjectShowPresenter()
        let router          =   GIFObjectShowRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        let requestModel = GIFObjectShowModels.Something.RequestModel()
        
        interactor?.doSomething(request: requestModel)
    }
}


// MARK: - GIFObjectShowDisplayLogic
extension GIFObjectShowViewController: GIFObjectShowDisplayLogic {
    func displaySomething(viewModel: GIFObjectShowModels.Something.ViewModel) {
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
}
