//
//  PartnerTableViewCell.swift
//  OMatKo
//
//  Created by Kacper Raczy on 23.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class PartnerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: Constraints
    private let livDefaultHeight: CGFloat = 190.0
    private let liv2nlDefaultSpace: CGFloat = 12.0
    private let nl2tlDefaultSpace: CGFloat = 8.0
    private let tl2dlDefaultSpace: CGFloat = 12.0
    @IBOutlet private weak var livHeightConstrant: NSLayoutConstraint!
    @IBOutlet private weak var liv2nlConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nl2tlConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tl2dlConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        titleLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
        descriptionLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    func setLogoImage(image: UIImage?) {
        if let image = image {
            logoImageView.isHidden = false
            livHeightConstrant.constant = livDefaultHeight
            liv2nlConstraint.constant = liv2nlDefaultSpace
            logoImageView.image = image
        } else {
            logoImageView.image = nil
            logoImageView.isHidden = true
            livHeightConstrant.constant = 0.0
            liv2nlConstraint.constant = 0.0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let label = object as? UILabel {
            if keyPath == "text" {
                if label.text != nil && !label.text!.isEmpty {
                    if label == titleLabel {
                        nl2tlConstraint.constant = nl2tlDefaultSpace
                    } else if label == descriptionLabel {
                        tl2dlConstraint.constant = tl2dlDefaultSpace
                    }
                } else {
                    if label == titleLabel {
                        nl2tlConstraint.constant = 0.0
                    } else if label == descriptionLabel {
                        tl2dlConstraint.constant = 0.0
                    }
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    deinit {
        titleLabel.removeObserver(self, forKeyPath: "text")
        descriptionLabel.removeObserver(self, forKeyPath: "text")
    }
    
}
