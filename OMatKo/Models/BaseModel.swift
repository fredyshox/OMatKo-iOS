//
//  BaseModel.swift
//  OMatKo
//
//  Created by Kacper Raczy on 20.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation

/**
 Declares methods required for local data deserialization
 */
protocol BaseModel {
    init?(dict: [String: Any])
    static var modelName: String { get }
}
