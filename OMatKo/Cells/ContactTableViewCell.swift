//
//  ContactTableViewCell.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImageView: RoundImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        phoneTextView.removePadding()
        phoneTextView.dataDetectorTypes = .phoneNumber
        phoneTextView.isEditable = false
        phoneTextView.tintColor = UIColor.omatkoPrimary
        emailTextView.removePadding()
        emailTextView.dataDetectorTypes = .all
        emailTextView.isEditable = false
        emailTextView.tintColor = UIColor.omatkoPrimary
    }
    
}

extension ContactTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
