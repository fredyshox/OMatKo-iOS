//
//  PlacesPagetTabStripViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 22.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class PlacesPagerTabStripViewController: ButtonBarPagerTabStripViewController, OMKMenu {
    
    var pagerItems : [PagerItem<Place.PlaceCategory>] = {
        var result: [PagerItem<Place.PlaceCategory>] = []
        
        for category in Place.PlaceCategory.allValues {
            let item = PagerItem<Place.PlaceCategory>(title: category.rawValue, data: category)
            result.append(item)
        }
        
        return result
    }()
    
    var places: [Place] = []
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        // pager style
        settings.style.buttonBarBackgroundColor = UIColor.omatkoPrimary
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
        settings.style.selectedBarBackgroundColor = UIColor.omatkoIndicator
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        
        setUpNavBar()
        title = "Places"
        super.viewDidLoad()
        
        loadPagerItems()
    }
    
    func loadPagerItems() {
        localDataService.fetchPlaces()
            .subscribe ({ (event) in
                switch event {
                case .next(let place):
                    self.places.append(place)
                case .error(let error):
                    log.error("Error: \(error.localizedDescription)")
                case .completed:
                    log.info("Completed")
                    self.notifyViewControllers()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func notifyViewControllers() {
        for vc in viewControllers {
            if let pvc = vc as? PlacesTableViewController {
                pvc.places = self.places.filter({ (place) -> Bool in
                    return place.category == pvc.placeCategory
                })
            }
        }
        
        self.reloadPagerTabStripView()
        self.buttonBarView.moveTo(index: 0, animated: false, swipeDirection: .left, pagerScroll: .yes)
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    private lazy var _viewControllers: [UIViewController] = {
        var vcArr: [UIViewController] = []
        
        for item in pagerItems {
            vcArr.append(PlacesTableViewController(pagerItem: item))
        }
        
        return vcArr
    }()
    
    override var viewControllers: [UIViewController] {
        return _viewControllers
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return viewControllers
    }
    
    // MARK: OMKMenu
    
    @objc func revealSideMenu(sender: Any?) {
        (self.viewDeckController as? SideMenuControllerAdapter)?.revealMenu(sender: sender)
    }
    
}
