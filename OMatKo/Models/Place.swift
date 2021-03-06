//
//  Place.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

/**
 * Represents location
 */
struct Place: Codable, BaseModel {
    let title: String
    let description: String
    let latitude: Double
    let longitude: Double
    let category: PlaceCategory
    
    enum PlaceCategory: String, Codable, Localizable {
        case sights = "SIGHTS"
        case shopping = "SHOPPING_AND_STATIONS"
        case entertainment = "ENTERTAINMENT"
        case food = "FOOD"
        case conference = "OMatKo"
        
        static var allValues: [PlaceCategory] {
            return [conference, entertainment, food, sights, shopping]
        }
        
        var localizedTitle: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    init(title: String, description: String, latitude: Double, longitude: Double, category: PlaceCategory) {
        self.title = title
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
    }
    
    // MARK: BaseModel
    
    init?(dict: [String: Any]) {
        guard let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let latitudeStr = dict["latitude"] as? String,
              let latitude = Double(latitudeStr),
              let longitudeStr = dict["longitude"] as? String,
              let longitude = Double(longitudeStr),
              let categoryVal = dict["category"] as? String,
              let category = PlaceCategory(rawValue: categoryVal)
        else {
                return nil
        }
        
        self.init(title: title, description: description, latitude: latitude, longitude: longitude, category: category)
    }
    
    static var modelName: String {
        return "place"
    }
}
