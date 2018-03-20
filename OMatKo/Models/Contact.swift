//
//  Contact.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

/**
 * Represents contact information for conference contributor
 */
struct Contact: Codable, BaseModel {
    let name: String
    let position: String
    let description: String
    let phoneNumber: String
    let email: String
    let imageUrl: String
    
    init(name: String, position: String, description: String, phoneNumber: String, email: String, imageUrl: String) {
        self.name = name
        self.position = position
        self.description = description
        self.phoneNumber = phoneNumber
        self.email = email
        self.imageUrl = imageUrl
    }
    
    // MARK: BaseModel
    
    init?(dict: [String: Any]) {
        guard let name = dict["name"] as? String,
              let position = dict["position"] as? String,
              let description = dict["description"] as? String,
              let phoneNumber = dict["phoneNumber"] as? String,
              let email = dict["email"] as? String,
              let imageUrl = dict["imageUrl"] as? String
        else {
            return nil
        }
        
        self.init(name: name, position: position, description: description, phoneNumber: phoneNumber, email: email, imageUrl: imageUrl)
    }
    
    static var modelName: String {
        return "person"
    }
}
