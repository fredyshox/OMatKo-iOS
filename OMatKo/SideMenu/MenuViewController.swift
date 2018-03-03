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

class MenuViewController: UITableViewController {
    
    var menuItems: [MenuItem] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var delegate: MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        log.info("Switching to: \(menuItem.viewControllerId)")
        self.delegate?.menu(self, didSelectItem: menuItem)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = menuItems[indexPath.row].title

        return cell
    }

}
