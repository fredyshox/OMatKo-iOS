//
//  LecturesPagerTabStripVC.swift
//  OMatKo
//
//  Created by Kacper Raczy on 16.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift

struct PagerItem<T> {
    var title: String
    var data: T
}

class LecturesPagerTabStripViewController: ButtonBarPagerTabStripViewController, OMKMenu {
    
    // Set this before using
    var lectureCategory: Event.Category! {
        didSet {
            if lectureCategory == .theoretical {
                self.title = NSLocalizedString("Theoretical lectures", comment: "")
            } else {
                self.title = NSLocalizedString("Popular science lectures", comment: "")
            }
        }
    }
    
    let pagerItems: [PagerItem<Event.ConferenceDay>] = {
        var result: [PagerItem<Event.ConferenceDay>] = []
        
        for day in Event.ConferenceDay.allValues {
            let item = PagerItem<Event.ConferenceDay>(title: day.localizedTitle, data: day)
            result.append(item)
        }
        
        return result
    }()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        // pager style
        settings.style.buttonBarBackgroundColor = UIColor.omatkoPrimary
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
        settings.style.selectedBarBackgroundColor = UIColor.omatkoIndicator
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        
        setUpNavBar()
        view.backgroundColor = UIColor.omatkoLightBackground
        
        
        super.viewDidLoad()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    func loadData() {
        AppDelegate.dataService.events
            .asObservable()
            .subscribe(onNext: { events in
                self.notifyViewControllers(events: events)
            })
            .disposed(by: disposeBag)
    }
    
    func notifyViewControllers(events: [Event]) {
        for vc in viewControllers {
            if let lvc = vc as? LecturesTableViewController {
                lvc.lectures = events.filter({ (event) -> Bool in
                    return event.category == self.lectureCategory && event.day == lvc.conferenceDay
                })
            }
        }
    }
    
    private lazy var _viewControllers: [UIViewController] = {
        var vcArr: [UIViewController] = []
        
        for item in pagerItems {
            vcArr.append(LecturesTableViewController(pagerItem: item))
        }
        
        return vcArr
    }()
    
    override var viewControllers: [UIViewController] {
        return _viewControllers
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return viewControllers
    }
    
    @objc func revealSideMenu(sender: Any?) {
        (self.viewDeckController as? SideMenuControllerAdapter)?.revealMenu(sender: sender)
    }
    
}
