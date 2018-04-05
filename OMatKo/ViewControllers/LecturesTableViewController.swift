//
//  EventsTableViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 01.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EventKit
import EventKitUI

class LecturesTableViewController: OMKTableViewController {
    
    // MARK: EventStore
    
    static let eventStore: EKEventStore = EKEventStore()
    
    // MARK: Properties
    
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
    
    func createCalendarEvent(_ lecture: Event, store: EKEventStore) -> EKEvent {
        let event = EKEvent(eventStore: store)
        event.title = lecture.title
        event.startDate = lecture.beginDate
        event.endDate = lecture.endDate
        
        event.location = lecture.place
        event.notes = lecture.shortDescription
        
        return event
    }

    // MARK: - Table view data source
    
    var expandedIndexPaths: [IndexPath] = []

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lectures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectureCell", for: indexPath) as! LectureTableViewCell
        
        let isExpanded = self.expandedIndexPaths.contains(indexPath)
        
        let lecture = self.lectures[indexPath.row]
        cell.descriptionLabel.text = isExpanded ? lecture.eventDescription : lecture.shortDescription
        cell.titleLabel.text = lecture.title
        cell.speakerLabel.text = lecture.presenter
        cell.scheduleLabel.text = formattedSchedule(for: lecture)
        cell.selectionStyle = .none
        
        let image = isExpanded ? UIImage(named: "show_less") : UIImage(named: "show_more")
        cell.moreImageView.image = image
        
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        updateExpandedIndexPath(indexPath: indexPath)
    }
    
    func updateExpandedIndexPath(indexPath: IndexPath) {
        let objectIndex = self.expandedIndexPaths.index(of: indexPath)
        
        if objectIndex != nil {
            self.expandedIndexPaths.remove(at: objectIndex!)
        } else {
            self.expandedIndexPaths.append(indexPath)
        }
        
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? LectureTableViewCell {
            log.info("Deselect : \(cell.isSelected)")
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
            
            let store = LecturesTableViewController.eventStore
            store.requestAccess(to: .event, completion: { (granted, error) in
                if !granted {
                    let title = NSLocalizedString("No permissions", comment: "")
                    let message = NSLocalizedString("Can't access caledar. Check your privacy settings.", comment: "")
                    let ok = NSLocalizedString("OK", comment: "")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: title,
                                                      message: message,
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let eventVC = EKEventEditViewController()
                    eventVC.eventStore = store
                    eventVC.event = self.createCalendarEvent(lecture, store: store)
                    eventVC.editViewDelegate = self

                    DispatchQueue.main.async {
                        self.present(eventVC, animated: true, completion: nil)
                    }
                }
            })
        }
    }
}

extension LecturesTableViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LecturesTableViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.title)
    }
}

