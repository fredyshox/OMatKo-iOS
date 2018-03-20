//
//  EventsTableViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 01.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class LecturesTableViewController: OMKTableViewController {
    
    // estimated row height
    static let lectureCellHeight: CGFloat = 123.0
    
    var lectures: Any!
    
    // MARK: Initialization
    
    init(title: String, data: Any) {
        super.init(style: .plain)
        
        self.title = title
        self.lectures = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // register cell nib
        let nib = UINib(nibName: "LectureTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "lectureCell")
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectureCell", for: indexPath) as! LectureTableViewCell
        
        // cell test
        let longDesc = "Long long Long long Long long Long long Long long Long long Long long Long long Description"
        cell.descriptionLabel.text = (indexPath.row % 2 != 0) ? longDesc : "Shot description"
        cell.titleLabel.text = (indexPath.row % 2 == 0) ? longDesc : "Short title"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return LecturesTableViewController.lectureCellHeight
    }
    
}

extension LecturesTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.title)
    }
}

