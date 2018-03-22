//
//  EditionViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 16.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class EditionViewController: OMKViewController {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var edition: Edition? {
        didSet {
            if isViewLoaded && edition != nil {
                updateUI(with: edition!)
            }
        }
    }
    
    func setUp(with pagerItem: PagerItem<Edition>) {
        self.title = pagerItem.title
        self.edition = pagerItem.data
    }
    
    func updateUI(with edition: Edition) {
        self.yearLabel.text = "2XX4"
        self.monthLabel.text = edition.title
        self.descriptionLabel.text = edition.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let edition = edition {
            updateUI(with: edition)
        }
    }
    
}

extension EditionViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.title)
    }
}
