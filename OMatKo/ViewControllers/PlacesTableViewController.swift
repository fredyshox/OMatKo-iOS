//
//  PlacesTableViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 16.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlacesTableViewController: OMKTableViewController {
    
    static let placeCellHeight: CGFloat = 92.0
    
    var places: [Place] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var placeCategory: Place.PlaceCategory!
    
    init(pagerItem: PagerItem<Place.PlaceCategory>) {
        super.init(style: .plain)
        self.placeCategory = pagerItem.data
        self.title = pagerItem.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView setup
        setUpTableView()
    }
    
    func setUpTableView() {
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "PlaceTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "placeCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        
        let place = places[indexPath.row]
        
        cell.titleLabel.text = place.title
        cell.descriptionLabel.text = place.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlacesTableViewController.placeCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension PlacesTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.title)
    }
}
