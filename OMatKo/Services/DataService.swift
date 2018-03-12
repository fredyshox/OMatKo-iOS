//
//  File.swift
//  OMatKo
//
//  Created by Kacper Raczy on 01.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import Foundation
import RxSwift

protocol DataService {
    var events: Variable<[Event]> { get }
}
