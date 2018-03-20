//
//  Edition.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

/**
 * Represents previous editions of conference.
 */
struct Edition: Codable {
    let title: String
    let description: String
    let imageUrl: String
    
    init(title: String, description: String, imageUrl: String) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
    }
    
    init?(dict: [String: Any]) {
        guard let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let imageUrl = dict["imageUrl"] as? String
        else {
            return nil
        }
        
        self.init(title: title, description: description, imageUrl: imageUrl)
    }
}
