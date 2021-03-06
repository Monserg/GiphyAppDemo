//
//  GIFObjectsShowViewController.swift
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
import Kingfisher

// MARK: - Input & Output protocols
protocol GIFObjectsShowDisplayLogic: class {
    // From CoreData
    func displayLoadObjectsGIF(fromViewModel viewModel: GIFObjectsShowModels.LoadObjectsGIF.ViewModel)
    
    // From Server
    func displayFetchGIFObjects(fromViewModel viewModel: GIFObjectsShowModels.FetchGIFObjects.ViewModel)
}

let paginationLimit = 14

class GIFObjectsShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: GIFObjectsShowBusinessLogic?
    var router: (NSObjectProtocol & GIFObjectsShowRoutingLogic & GIFObjectsShowDataPassing)?
    
    // Data source
    var objectsGIF: [ObjectGIF]?

    // Search
    var filtered: [ObjectGIF] = []
    var searchActive: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var searchText = ""
    
    // Pagination (0 - to start & clean datasource)
    var paginationOffset = 0
    var paginationPage = 0
    var countMax: Int32 = 0
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
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
        let viewController          =   self
        let interactor              =   GIFObjectsShowInteractor(coreDataManager: CoreDataManager.instance)
        let presenter               =   GIFObjectsShowPresenter(coreDataManager: CoreDataManager.instance)
        let router                  =   GIFObjectsShowRouter()
        
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
        
        searchControllerCreate()
        loadObjectsGIF()
    }
    
    
    // MARK: - Custom Functions
    func searchControllerCreate() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Enter search keywords", comment: "Search keywords")
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    func fetchGIFObjects() {
        spinner.startAnimating()
        paginationOffset = objectsGIF == nil ? 0 : objectsGIF!.count + 1

        guard Connectivity.isNetworkAvailable() else {
            loadObjectsGIF()
            return
        }
        
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 0.5)
            
            OperationQueue.main.addOperation() {
                self.view.isUserInteractionEnabled = false
                let requestModel = GIFObjectsShowModels.FetchGIFObjects.RequestModel(parameterQ: self.searchText, parameterOffset: self.paginationOffset)
                self.interactor?.fetchGIFObjects(withRequestModel: requestModel)
            }
        }
    }

    func loadObjectsGIF() {
        spinner.startAnimating()
        
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 0.005)
            
            OperationQueue.main.addOperation() {
                let requestModel = GIFObjectsShowModels.LoadObjectsGIF.RequestModel(objectsCount: self.objectsGIF == nil ? 0 : self.objectsGIF!.count)
                self.interactor?.loadObjectsGIF(withRequestModel: requestModel)
            }
        }
    }
    
    func refreshObjectsGIF(fromArray objects: [ObjectGIF]?) {
        objectsGIF = objects
        
        OperationQueue.main.addOperation() {
            self.collectionView.reloadData()
            self.spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension GIFObjectsShowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch searchActive {
        case true:
            return filtered.count

        default:
            return objectsGIF == nil ? 0 : objectsGIF!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GIFCollectionViewCell
        let objectGIF = objectsGIF![indexPath.row]
        
        cell.spinner.startAnimating()
        cell.importDateTimeLabel.text = "\(indexPath.row)"

        if let imageURL = objectGIF.fixed_width {
            print("\(indexPath.row). \(imageURL)")
            
            DispatchQueue.main.async {
                Thread.sleep(forTimeInterval: 0.005)
                
                OperationQueue.main.addOperation() {
                    cell.imageView.kf.setImage(with: URL(string: imageURL)!,
                                               placeholder: nil,
                                               options: [.transition(ImageTransition.fade(1)), .cacheOriginalImage,
                                                         .processor(ResizingImageProcessor(referenceSize: cell.imageView.frame.size,
                                                                                           mode: .aspectFill))],
                                               completionHandler: { image, error, cacheType, imageURL in
                                                cell.imageView.kf.cancelDownloadTask()
                                                cell.spinner.stopAnimating()
                    })
                }
            }
        } else {
            cell.imageView.image = UIImage.init(named: "no-image-3")
            cell.spinner.stopAnimating()
        }

        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension GIFObjectsShowViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToGIFObjectShow(objectGIF: objectsGIF![indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == objectsGIF!.count - 2 && objectsGIF!.count % paginationLimit == 0 && indexPath.row < countMax - 2 {
            (searchText.isEmpty) ? loadObjectsGIF() : fetchGIFObjects()
            paginationPage += 1
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension GIFObjectsShowViewController: UICollectionViewDelegateFlowLayout {
    // Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 8.0) / 2
        
        return CGSize.init(width: cellWidth, height: cellWidth)
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (objectsGIF?.count == 0) ? CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height) : .zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "Header",
                                                                             for: indexPath)
            
            return headerView
            
        default:
            assert(false, NSLocalizedString("Unexpected element kind", comment: "Collection cell kind error`"))
        }
    }
}


// MARK: - UISearchControllerDelegate
extension GIFObjectsShowViewController: UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text

        if let items = objectsGIF {
            filtered = items.filter({ (item) -> Bool in
                let searchText: NSString = item.searchText as NSString
                
                return (searchText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            
            collectionView.reloadData()
        }
    }
}


// MARK: - UISearchBarDelegate
extension GIFObjectsShowViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchText = ""
        self.dismiss(animated: true, completion: nil)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        searchActive = false
        searchController.isActive = false
        objectsGIF = []
        fetchGIFObjects()
        paginationPage = 0
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
}


// MARK: - UISearchResultsUpdating
extension GIFObjectsShowViewController: UISearchResultsUpdating {

}


// MARK: - GIFObjectsShowDisplayLogic
extension GIFObjectsShowViewController: GIFObjectsShowDisplayLogic {
    // From CoreData
    func displayLoadObjectsGIF(fromViewModel viewModel: GIFObjectsShowModels.LoadObjectsGIF.ViewModel) {
        // NOTE: Display the result from the Presenter
        countMax = viewModel.countMax
        refreshObjectsGIF(fromArray: viewModel.displayedGIFObjects)
    }

    // From Server
    func displayFetchGIFObjects(fromViewModel viewModel: GIFObjectsShowModels.FetchGIFObjects.ViewModel) {
        // NOTE: Display the result from the Presenter
        countMax = viewModel.countMax
        refreshObjectsGIF(fromArray: viewModel.displayedGIFObjects)
    }
}
