//
//  FirebaseDataService.swift
//  OMatKo
//
//  Created by Kacper Raczy on 01.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import RxSwift
import Firebase
import CodableFirebase

class FirebaseDataService: DataService {
    
    private var _events: Variable<[Event]> = Variable([])
    
    // MARK: DataService protocol
    
    var events: Variable<[Event]> {
        return Variable<[Event]>([])
    }
    
    // MARK: Encoders & Decoders
    
    private let decoder: FirebaseDecoder = FirebaseDecoder()
    private let encoder: FirebaseEncoder = FirebaseEncoder()
    
    // MARK: Firebase database references
    private let ref: DatabaseReference = Database.database().reference()
    private let eventsRef: DatabaseReference = Database.database().reference(withPath: "events")
    
    // MARK: Initialization
    
    private let disposeBag = DisposeBag()
    
    func start() {
        self.fetchEvents().subscribe(onNext: { [weak self] newEvents in
            self?.events.value.removeAll()
            self?.events.value.append(contentsOf: newEvents)
        }).disposed(by: disposeBag)
    }
    
    // MARK: Fetch/Send Methods

    func fetchEvents() -> Observable<[Event]> {
        return Observable<[Event]>.create({ (observer) -> Disposable in
            let obs = self.eventsRef.observe(.value, with: { (snapshot) in
                guard let _ = snapshot.value else {
                    return
                }
                
                var events: [Event] = []
                
                for childSnap in snapshot.children {
                    do {
                        let model = try self.decoder.decode(Event.self, from: childSnap)
                        events.append(model)
                    } catch let err {
                        log.error("Unable to deserialie event: \(err.localizedDescription)")
                    }
                }
                
                observer.onNext(events)
            })
            
            return Disposables.create {
                self.eventsRef.removeObserver(withHandle: obs)
            }
        })
    }
    
}
