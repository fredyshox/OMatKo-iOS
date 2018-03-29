//
//  LecturesPagerTabStripVC.swift
//  OMatKo
//
//  Created by Kacper Raczy on 16.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip

struct PagerItem<T> {
    var title: String
    var data: T
}

class LecturesPagerTabStripViewController: ButtonBarPagerTabStripViewController, OMKMenu {
    
    let pagerItems: [PagerItem<String>] = [
        PagerItem(title: "Friday", data: "D"),
        PagerItem(title: "Saturday", data: "T"),
        PagerItem(title: "Sunday", data: "F")
    ]
    
    override func viewDidLoad() {
        // pager style
        settings.style.buttonBarBackgroundColor = UIColor.omatkoPrimary
        settings.style.buttonBarItemBackgroundColor = UIColor.clear
        settings.style.selectedBarBackgroundColor = UIColor.omatkoIndicator
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        
        setUpNavBar()
        title = "Theoretical Lectures"
        view.backgroundColor = UIColor.omatkoLightBackground
        
        super.viewDidLoad()
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var vcArr: [UIViewController] = []
        for item in pagerItems {
            vcArr.append(LecturesTableViewController(title: item.title, data: item.data))
        }
        
        return vcArr
    }
    
    @objc func revealSideMenu(sender: Any?) {
        (self.viewDeckController as? SideMenuControllerAdapter)?.revealMenu(sender: sender)
    }
    
}
