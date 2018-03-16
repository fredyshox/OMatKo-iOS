//
//  ContactsTableViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class ContactsTableViewController: OMKTableViewController {
    
    static let contactCellHeight: CGFloat = 320.0
    
    // MARK: VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTableView() {
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "contactCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell

        cell.contactImageView.backgroundColor = UIColor.omatkoSecondary
        
        // cell test
        let longDesc = "Long long Long long Long long Long long Long long Long long Long long Long long Description"
        cell.descriptionLabel.text = (indexPath.row % 2 != 0) ? longDesc : "Shot description"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactsTableViewController.contactCellHeight
    }
    
}
