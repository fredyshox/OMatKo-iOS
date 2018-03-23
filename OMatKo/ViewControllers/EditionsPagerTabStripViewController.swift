//
//  EditionsPagerTabStripViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 22.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class EditionsPagerTabStripViewController: ButtonBarPagerTabStripViewController, OMKMenu {
    
    var pagerItems: [PagerItem<Edition>] = [
        PagerItem<Edition>(title: "Loading...", data: Edition(title: "", description: "", imageUrl: ""))
    ]
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        // pager style
        settings.style.buttonBarBackgroundColor = UIColor.omatkoPrimary
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
        settings.style.selectedBarBackgroundColor = UIColor.omatkoIndicator
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        
        setUpNavBar()
        title = "Editions"
        
        super.viewDidLoad()
        
        loadPagerItems()
    }
    
    func loadPagerItems() {
        pagerItems.removeAll()
        localDataService.fetchEditions()
            .subscribe({ (event) in
                switch event {
                case .next(let edition):
                    self.pagerItems.append(PagerItem(title: edition.title, data: edition))
                case .error(let error):
                    log.error("Error: \(error.localizedDescription)")
                case .completed:
                    log.info("Completed")
                    self.reloadPagerTabStripView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcArr: [UIViewController] = []
        let storyboard = UIStoryboard(name: "Editions", bundle: nil)
        
        for item in pagerItems {
            let vc = storyboard.instantiateViewController(withIdentifier: "editionVC") as! EditionViewController
            vc.setUp(with: item)
            
            vcArr.append(vc)
        }
        
        return vcArr
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    // MARK: OMKMenu
    
    @objc func revealSideMenu(sender: Any?) {
        (self.viewDeckController as? SideMenuControllerAdapter)?.revealMenu(sender: sender)
    }
    
}
