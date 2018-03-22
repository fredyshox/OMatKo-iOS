//
//  LocalDataService.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import RxSwift

enum LocalDataServiceError: Error {
    case fileNotFound(String)
    case deserialization(String)
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound(let name):
            return "Unable to find file: \(name)"
        case .deserialization(let reason):
            return "Unable to deserialize file. \(reason)"
        }
    }
}

protocol LocalDataService {
    func fetchContacts() -> Observable<Contact>
    func fetchEditions() -> Observable<Edition>
    func fetchPlaces() -> Observable<Place>
    func fetchSponsors() -> Observable<Sponsor>
}
