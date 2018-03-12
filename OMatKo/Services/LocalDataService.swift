//
//  LocalDataService.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import RxSwift

protocol LocalDataService {
    func fetchContacts() -> Observable<Contact>
    func fetchEditions() -> Observable<Edition>
    func fetchPlaces() -> Observable<Place>
}
