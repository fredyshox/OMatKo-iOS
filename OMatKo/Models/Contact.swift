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
struct Contact: Codable {
    let name: String
    let position: String
    let description: String
    let phoneNumber: String
    let email: String
    let imageUrl: String
}
