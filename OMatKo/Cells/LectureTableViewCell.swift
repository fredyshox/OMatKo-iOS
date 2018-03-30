//
//  LectureTableViewCell.swift
//  OMatKo
//
//  Created by Kacper Raczy on 27.02.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class LectureTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var moreImageView: UIImageView!
    
    weak var delegate: LectureTableViewCellDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addToCalendar(_ sender: Any) {
        self.delegate?.calendarButtonClicked(self)
    }
    
}

protocol LectureTableViewCellDelegate: AnyObject {
    func calendarButtonClicked(_ cell: LectureTableViewCell)
}
