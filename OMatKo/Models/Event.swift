//
//  Event.swift
//  OMatKo
//
//  Created by Kacper Raczy on 27.02.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation
import CoreData

/**
 Object which represents event.
 */
class Event: Codable {
    
    enum ConferenceDay: String, Codable {
        case friday = "FRIDAY"
        case saturday = "SATURDAY"
        case sunday = "SUNDAY"
    }
    
    enum Category: String, Codable {
        case theoretical = "THEORETICAL"
        case popularScience = "POPULARSCIENCE"
    }
    
    // MARK: Stored Properties
    
    var id: String
    
    var title: String
    
    var presenter: String
    
    var place: String

    var eventDescription: String
    
    var shortDescription: String
    
    var beginDate: Date
 
    var endDate: Date
 
    var category: Category
    
    var day: ConferenceDay
    
    init?(dict: [String: Any]) {
        guard let id = dict[CodingKeys.id.stringValue] as? String,
              let title = dict[CodingKeys.title.stringValue] as? String,
              let presenter = dict[CodingKeys.presenter.stringValue] as? String,
              let place = dict[CodingKeys.place.stringValue] as? String,
              let eventDescription = dict[CodingKeys.eventDescription.stringValue] as? String,
              let shortDescription = dict[CodingKeys.shortDescription.stringValue] as? String,
              let beginDateVal = dict[CodingKeys.beginDate.stringValue] as? TimeInterval,
              let endDateVal = dict[CodingKeys.endDate.stringValue] as? TimeInterval,
              let categoryVal = dict[CodingKeys.category.stringValue] as? String,
              let category = Event.Category(rawValue: categoryVal),
              let dayVal = dict[CodingKeys.day.stringValue] as? String,
              let day = Event.ConferenceDay(rawValue: dayVal)
        else {
             return nil
        }
        
        self.id = id
        self.title = title
        self.presenter = presenter
        self.place = place
        self.eventDescription = eventDescription
        self.shortDescription = shortDescription
        self.beginDate = Date(timeIntervalSince1970: beginDateVal)
        self.endDate = Date(timeIntervalSince1970: endDateVal)
        self.category = category
        self.day = day
    }
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case presenter
        case place
        case eventDescription = "longDescription"
        case shortDescription
        case beginDate = "beginTime"
        case endDate = "endTime"
        case category = "type"
        case day
    }
    
}
