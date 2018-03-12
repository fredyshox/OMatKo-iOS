//
//  Place.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

struct Place: Codable {
    let title: String
    let descritpion: String
    let latitude: Double
    let longitude: Double
    let category: PlaceCategory
    
    enum PlaceCategory: String, Codable {
        case sights = "SIGHTS"
        case shopping = "SHOPPING_AND_STATIONS"
        case entertainment = "ENTERTAINMENT"
        case food = "FOOD"
        case conference = "OMatKo"
    }
}
