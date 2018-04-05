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
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        preferredContentSize = CGSize(width: 280, height: UIScreen.main.bounds.height)
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setUpTableView()
        }
    }
    
    // MARK: Actions
    
    @IBAction func openSnapchat(_ sender: UIButton) {
        let snapUrl = URL(string: "snapchat://add/omatkopwr")
        if snapUrl != nil && UIApplication.shared.canOpenURL(snapUrl!){
            openUrl(snapUrl!)
        } else if let url = URL(string: "https://snapchat.com/add/omatkopwr") {
            openUrl(url)
        }
    }
    
    @IBAction func openFb(_ sender: UIButton) {
        let fbUrl = URL(string: "fb://page/269551433187258")
        if fbUrl != nil && UIApplication.shared.canOpenURL(fbUrl!) {
            openUrl(fbUrl!)
        } else if let url = URL(string: "https://www.facebook.com/omatkopwr"){
            openUrl(url)
        }
    }
    
    @IBAction func openInstagram(_ sender: UIButton) {
        let instaUrl = URL(string: "instagram://user?username=USERNAME")
        if instaUrl != nil && UIApplication.shared.canOpenURL(instaUrl!) {
            openUrl(instaUrl!)
        } else if let url = URL(string: "https://instagram.com/_u/omatko.pwr") {
            openUrl(url)
        }
    }
    
    private func openUrl(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        if !menuItems.isEmpty {
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        }
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
}
