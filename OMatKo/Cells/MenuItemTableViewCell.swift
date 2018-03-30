//
//  MenuItemTableViewCell.swift
//  OMatKo
//
//  Created by Kacper Raczy on 03.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    static var defaultHeight: CGFloat = 44.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            titleLabel.textColor = UIColor.omatkoSecondary
            iconImageView.tintColor = UIColor.omatkoSecondary
        } else {
            titleLabel.textColor = UIColor.darkGray
            iconImageView.tintColor = UIColor.darkGray
        }
    }
    
}
