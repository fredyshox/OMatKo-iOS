//
//  SponsorsPagerTabStripViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 22.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class PartnersPagerTabStripViewController: ButtonBarPagerTabStripViewController, OMKMenu {
    
    var pagerItems: [PagerItem<Sponsor.Category>] = {
        var result: [PagerItem<Sponsor.Category>] = []
        
        for category in Sponsor.Category.allValues {
            let item = PagerItem<Sponsor.Category>(title: category.rawValue, data: category)
            result.append(item)
        }
        
        return result
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var sponsors: [Sponsor] = []
    
    override func viewDidLoad() {
        // pager style
        settings.style.buttonBarBackgroundColor = UIColor.omatkoPrimary
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
        settings.style.selectedBarBackgroundColor = UIColor.omatkoIndicator
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        
        setUpNavBar()
        title = "Sponsors"
        loadPagerItems()
        
        super.viewDidLoad()
    }
    
    func loadPagerItems() {
        localDataService.fetchSponsors()
            .subscribe({ (event) in
                switch event {
                case .next(let sponsor):
                    self.sponsors.append(sponsor)
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
        
    }
    
    private lazy var _viewControllers: [UIViewController] = {
        var vcArr: [UIViewController] = []
        let storyboard = UIStoryboard(name: "Partners", bundle: nil)
        
        for item in pagerItems {
            let vc = storyboard.instantiateViewController(withIdentifier: "partnersVC")
            vcArr.append(vc)
        }
        
        
        return vcArr
    }()
    
    override var viewControllers: [UIViewController] {
        return _viewControllers
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return viewControllers
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
