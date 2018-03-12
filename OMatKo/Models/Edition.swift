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
}
