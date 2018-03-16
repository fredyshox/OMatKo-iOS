//
//  SideMenuManager.swift
//  OMatKo
//
//  Created by Kacper Raczy on 02.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import ViewDeck

class SideMenuManager: SideMenuControllerDataSource, MenuViewControllerDelegate {
    
    // MARK: Properties
    
    private var _sideMenuController: SideMenuControllerAdapter!
    
    private var _menuController: MenuViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
        
        return vc
    }()
    
    private var viewControllerDict: [String: UIViewController] = [:]
    
    private let _menuItems: [MenuItem] = [
        MenuItem(viewControllerId: "lectureVC", title: "Theoretical lectures", iconName: "book"),
        MenuItem(viewControllerId: "invalid", title: "Science lectures", iconName: "chart"),
        MenuItem(viewControllerId: "votesVC", title: "Vote for essays", iconName: "votes"),
        MenuItem(viewControllerId: "mapVC", title: "Map", iconName: "location"),
        MenuItem(viewControllerId: "editionsVC", title: "Previous editions", iconName: "history"),
        MenuItem(viewControllerId: "invalid", title: "Sponsors", iconName: "heart"),
        MenuItem(viewControllerId: "contactsVC", title: "Contact", iconName: "mail")
    ]
    
    // MARK: Initialization
    
    init() {
        let centerVC = viewController(forId: initialMenuItem().viewControllerId)
        self._sideMenuController = SideMenuController(center: centerVC, leftViewController: _menuController)
        
        self._menuController.menuItems = menuItems
        self._menuController.delegate = self
    }
    
    // MARK: Private helper methods
    
    private func getViewController(id: String) -> UIViewController {
        if viewControllerDict[id] == nil {
            viewControllerDict[id] = instantiateViewController(id: id)
        }
        
        return viewControllerDict[id]!
    }
    
    private func instantiateViewController(id: String) -> UIViewController{
        var vc: UIViewController!
        switch id {
        case "mapVC":
            vc = PlacesTableViewController(style: .plain)
        case "lectureVC":
            vc = LecturesTableViewController(style: .plain)
        case "contactsVC":
            vc = ContactsTableViewController(style: .plain)
        case "editionsVC":
            let storyboard = UIStoryboard(name: "Editions", bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: "editionVC")
        case "votesVC":
            vc = OMKNavigationController()
        default:
            vc = OMKViewController()
        }
        
        vc = vc ?? OMKViewController()
        
        if let _ = vc as? UINavigationController {
            return vc
        } else {
            return UINavigationController(rootViewController: vc)
        }
    }
    
    // MARK: MainViewControllerDataSource
    
    var menuItems: [MenuItem] {
        return _menuItems
    }
    
    var sideMenuAdapter: SideMenuControllerAdapter {
        get {
            return _sideMenuController
        }
        set {
            self._sideMenuController = newValue
        }
    }
    
    func viewController(forId id: String) -> UIViewController {
        return getViewController(id: id)
    }
    
    func initialMenuItem() -> MenuItem {
        return _menuItems[0]
    }
    
    // MARK: MenuViewControllerDelegate
    
    func menu(_ menuVC: MenuViewController, didSelectItem item: MenuItem) {
        guard let sideMC = _sideMenuController else {
            return
        }
    
        let vc = viewController(forId: item.viewControllerId)
        sideMC.swapContent(forVC: vc)
        sideMC.closeMenu(sender: nil)
    }

}
