//
//  PlacesTableViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 16.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class PlacesTableViewController: OMKTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView setup
        self.tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "PlaceTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "placeCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        
        let longDesc = "Long long Long long Long long Long long Long long Long long Long long Long long Description"
        cell.descriptionLabel.text = (indexPath.row % 2 != 0) ? longDesc : "Shot description"
        cell.titleLabel.text = (indexPath.row % 2 == 0) ? longDesc : "Short title"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
