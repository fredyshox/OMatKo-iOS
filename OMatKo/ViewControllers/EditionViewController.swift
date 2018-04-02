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
    @IBOutlet weak var imageView: RoundImageView!
    // Image View to Description Label constraint
    // change constant to 0 when image view is hidden
    @IBOutlet weak var iv2dlConstraint: NSLayoutConstraint!
    
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
        let titleWords = edition.title.split(separator: " ")
        self.yearLabel.text = String(titleWords.last ?? "20XX")
        self.monthLabel.text = String(titleWords.first ?? "Month")
        self.descriptionLabel.text = edition.description
        if edition.imageUrl.isEmpty {
            self.imageView.isHidden = true
            self.imageView.image = nil
        } else {
            self.imageView.isHidden = false
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    if let url = URL(string: edition.imageUrl) {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                } catch let err {
                    log.error("Unable to load image: \(err.localizedDescription)")
                    //change image
                }
            }
        }
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
