//
//  OMKViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 15.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

@objc protocol OMKMenu: AnyObject {
    @objc func revealSideMenu(sender: Any?)
}

extension OMKMenu where Self: UIViewController  {
    
    func createMenuButton() -> UIBarButtonItem {
        let btnImage = UIImage(named: "menu_bars")
        let button = UIBarButtonItem(image: btnImage,
                                     style: .plain,
                                     target: self,
                                     action: #selector(revealSideMenu(sender:)))
        
        return button
    }
}

class OMKViewController: UIViewController, OMKMenu{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    @objc func revealSideMenu(sender: Any?) {
        (self.viewDeckController as? SideMenuControllerAdapter)?.revealMenu(sender: sender)
    }
    
}

class OMKTableViewController: UITableViewController, OMKMenu {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = createMenuButton()
    }
    
    @objc func revealSideMenu(sender: Any?) {
        (self.viewDeckController as? SideMenuControllerAdapter)?.revealMenu(sender: sender)
    }
    
}
