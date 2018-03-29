//
//  SponsorsViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 23.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PartnersViewController: OMKTableViewController {
    
    static let partnerCellHeight: CGFloat = 330.0
    
    var category: Sponsor.Category!
    
    var sponsors: [Sponsor] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(pagerItem: PagerItem<Sponsor.Category>) {
        super.init(style: .plain)
        self.category = pagerItem.data
        self.title = pagerItem.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView setup
        setUpTableView()
    }
    
    func setUpTableView() {
        
        let nib = UINib(nibName: "PartnerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "partnerCell")
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sponsors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partnerCell", for: indexPath) as! PartnerTableViewCell
        
        let sponsor = self.sponsors[indexPath.row]
        cell.nameLabel.text = sponsor.name
        cell.titleLabel.text = sponsor.title
        cell.descriptionLabel.text = sponsor.description
        
        if sponsor.imageUrl.isEmpty {
            cell.setLogoImage(image: nil)
        } else {
            cell.setLogoImage(image: UIImage(named: sponsor.imageUrl))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return PartnersViewController.partnerCellHeight
    }

}

extension PartnersViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.title)
    }
}
