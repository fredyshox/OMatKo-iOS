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
    
    var lectures: [Event] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var conferenceDay: Event.ConferenceDay!
    
    // MARK: Initialization
    
    init(pagerItem: PagerItem<Event.ConferenceDay>) {
        super.init(style: .plain)
        
        self.title = pagerItem.title
        self.conferenceDay = pagerItem.data
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
        return self.lectures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectureCell", for: indexPath) as! LectureTableViewCell
        
        let lecture = lectures[indexPath.row]
        cell.descriptionLabel.text = lecture.eventDescription
        cell.titleLabel.text = lecture.title

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

