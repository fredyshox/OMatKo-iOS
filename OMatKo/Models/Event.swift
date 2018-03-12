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
    
    // MARK: Stored Properties
    
    var id: String
    
    var title: String
    
    var presenter: String
    
    var place: String

    var eventDescription: String
    
    var beginDate: Date
 
    var endDate: Date
 
    var type: String
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case presenter
        case place
        case eventDescription
        case beginDate
        case endDate
        case type
    }
    
}
