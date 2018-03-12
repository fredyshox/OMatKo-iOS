//
//  XMLLocalDataService.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import RxSwift

class XMLLocalDataService: LocalDataService {
    
    
    // MARK: LocalDataService
    
    func fetchPlaces() -> Observable<Place> {
        return Observable<Place>.create({ (observer) -> Disposable in
            //TODO
            return Disposables.create()
        })
    }
    
    func fetchContacts() -> Observable<Contact> {
        return Observable<Contact>.create({ (observer) -> Disposable in
            //TODO
            return Disposables.create()
        })
    }
    
    func fetchEditions() -> Observable<Edition> {
        return Observable<Edition>.create({ (observer) -> Disposable in
            //TODO
            return Disposables.create()
        })
    }
}
