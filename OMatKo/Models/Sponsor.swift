//
//  Sponsor.swift
//  OMatKo
//
//  Created by Kacper Raczy on 22.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

struct Sponsor: Codable, BaseModel {
    let name: String
    let title: String
    let description: String
    let imageUrl: String
    let category: Category
    
    
    enum Category: String, Codable {
        case sponsor = "sponsor"
        case supportingCompany = "supporting_company"
        case media = "media"
        case organizer = "organizer"
        
        static var allValues: [Category] = [sponsor, supportingCompany, media, organizer]
    }
    
    init(name: String, title: String, description: String, imageUrl: String, category: Category) {
        self.name = name
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
    }
    
    init?(dict: [String : Any]) {
        guard let name = dict["name"] as? String,
              let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let imageUrl = dict["imageId"] as? String,
              let categoryValue = dict["category"] as? String,
              let category = Sponsor.Category(rawValue: categoryValue)
        else {
                return nil
        }
        
        self.init(name: name, title: title, description: description, imageUrl: imageUrl, category: category)
    }
    
    static var modelName: String {
        return "sponsor"
    }
}
