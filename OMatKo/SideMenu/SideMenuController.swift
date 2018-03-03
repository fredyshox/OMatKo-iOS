//
//  MainViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 01.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import ViewDeck

protocol SideMenuControllerDataSource: AnyObject {
    var menuItems: [MenuItem] { get }
    
    func viewController(forId id: String) -> UIViewController
    func initialMenuItem() -> MenuItem
}

@objc protocol SideMenuControllerAdapter: AnyObject {
    @objc func revealMenu(sender: Any)
    func swapContent(forVC viewController: UIViewController)
    var container: UIViewController { get }
}

class SideMenuController: IIViewDeckController, SideMenuControllerAdapter {
    
    // MARK: SideMenuControllerAdapter
    
    @objc
    func revealMenu(sender: Any) {
        self.open(.left, animated: true)
    }
    
    func swapContent(forVC viewController: UIViewController) {
        self.centerViewController = viewController
    }
    
    var container: UIViewController {
        return self
    }

}
