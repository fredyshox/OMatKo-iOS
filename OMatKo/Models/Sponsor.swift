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
    
    init?(dict: [String : Any]) {
        return nil
    }
    
    static var modelName: String {
        return "sponsor"
    }
}
