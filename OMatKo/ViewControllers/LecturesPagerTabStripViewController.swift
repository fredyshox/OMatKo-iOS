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
    var lectureCategory: Event.Category!
    
    let pagerItems: [PagerItem<Event.ConferenceDay>] = [
        PagerItem(title: "Friday", data: Event.ConferenceDay.friday),
        PagerItem(title: "Saturday", data: Event.ConferenceDay.saturday),
        PagerItem(title: "Sunday", data: Event.ConferenceDay.sunday)
    ]
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        // pager style
        settings.style.buttonBarBackgroundColor = UIColor.omatkoPrimary
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
        settings.style.selectedBarBackgroundColor = UIColor.omatkoIndicator
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        
        setUpNavBar()
        title = "Theoretical Lectures"
        view.backgroundColor = UIColor.omatkoLightBackground
        
        
        super.viewDidLoad()
        
        self.reloadPagerTabStripView()
        loadData()
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
