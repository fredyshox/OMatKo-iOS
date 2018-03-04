//
//  MenuViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 01.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func menu(_ menuVC: MenuViewController, didSelectItem item: MenuItem)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var menuItems: [MenuItem] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var delegate: MenuViewControllerDelegate?

}

// MARK: - Table view data source

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        log.info("Switching to: \(menuItem.viewControllerId)")
        self.delegate?.menu(self, didSelectItem: menuItem)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = menuItems[indexPath.row].title
        
        return cell
    }
    
}
