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
    
    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setUpTableView()
        }
    }
    
    // MARK: Actions
    
    @IBAction func openSnapchat(_ sender: UIButton) {
        log.info("Open snapchat")
    }
    
    @IBAction func openFb(_ sender: UIButton) {
        log.info("Open facebook")
    }
    
    @IBAction func openInstagram(_ sender: UIButton) {
        log.info("Open instagram")
    }
    
    // MARK: Properties
    
    var menuItems: [MenuItem] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var delegate: MenuViewControllerDelegate?
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "MenuItemTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "menuCell")
    }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuItemTableViewCell
        
        let item = menuItems[indexPath.row]
        cell.titleLabel.text = item.title
        
        let image = UIImage(named: item.iconName)?.withRenderingMode(.alwaysTemplate)
        cell.iconImageView.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuItemTableViewCell.defaultHeight
    }
    
}
