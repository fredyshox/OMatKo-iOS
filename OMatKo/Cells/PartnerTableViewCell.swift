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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
