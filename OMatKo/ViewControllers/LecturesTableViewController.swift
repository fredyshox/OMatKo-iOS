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
    static let scheduleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Paris")
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter
    }()
    
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
        tableView.allowsMultipleSelection = true
    }
    
    // MARK: Helper
    
    func formattedSchedule(for event: Event) -> String {
        var str = "\(LecturesTableViewController.scheduleDateFormatter.string(from: event.beginDate))"
        str += " - \(LecturesTableViewController.scheduleDateFormatter.string(from: event.endDate))"
        
        return str
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
        
        let lecture = self.lectures[indexPath.row]
        cell.descriptionLabel.text = lecture.shortDescription
        cell.titleLabel.text = lecture.title
        cell.speakerLabel.text = lecture.presenter
        cell.scheduleLabel.text = formattedSchedule(for: lecture)
        cell.selectionStyle = .none
        
        let image = cell.isSelected ? UIImage(named: "show_less") : UIImage(named: "show_more")
        cell.moreImageView.image = image
        
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? LectureTableViewCell {
            let lecture = self.lectures[indexPath.row]
            cell.moreImageView.image = UIImage(named: "show_less")
            cell.descriptionLabel.text = lecture.eventDescription
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                tableView.deselectRow(at: indexPath, animated: false)
                return nil
            } else {
                return indexPath
            }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? LectureTableViewCell {
            let lecture = self.lectures[indexPath.row]
            cell.moreImageView.image = UIImage(named: "show_more")
            cell.descriptionLabel.text = lecture.shortDescription
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return LecturesTableViewController.lectureCellHeight
    }
    
}

extension LecturesTableViewController: LectureTableViewCellDelegate {
    func calendarButtonClicked(_ cell: LectureTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let lecture = self.lectures[indexPath.row]
            
            // TODO open caledar
        }
    }
}

extension LecturesTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.title)
    }
}

