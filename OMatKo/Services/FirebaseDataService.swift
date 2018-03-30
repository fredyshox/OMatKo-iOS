//
//  FirebaseDataService.swift
//  OMatKo
//
//  Created by Kacper Raczy on 01.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import RxSwift
import Firebase

class FirebaseDataService: DataService {
    
    private var _events: Variable<[Event]> = Variable([])
    
    // MARK: DataService protocol
    
    var events: Variable<[Event]> {
        return _events
    }
    
    // MARK: Firebase database references
    private let ref: DatabaseReference = Database.database().reference()
    private let eventsRef: DatabaseReference = Database.database().reference(withPath: "events")
    private let votesRef: DatabaseReference = Database.database().reference(withPath: "results")
    
    // MARK: RX
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initialization
    
    func start() {
        self.fetchEvents().subscribe(onNext: { newEvents in
            self._events.value.removeAll()
            self._events.value.append(contentsOf: newEvents)
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
                    if  let snap = childSnap as? DataSnapshot,
                        let dict = self.prepareEventDict(snap: snap),
                        let model = Event(dict: dict) {
                        events.append(model)
                    } else {
                        observer.onError(DataServiceError.serialization)
                    }
                }
                
                observer.onNext(events)
            })
            
            return Disposables.create {
                self.eventsRef.removeObserver(withHandle: obs)
            }
        })
    }
    
    
    /**
     Returns observable map [<eventId>:<mark>]
     */
    func fetchVotes() -> Observable<[String: Int]> {
        return Observable<[String: Int]>.create({ (observer) -> Disposable in
            
            
            return Disposables.create()
        })
    }
    
    func vote(forEventWithId eventId: String, mark: Int) throws {
        guard let user = Auth.auth().currentUser else {
            throw DataServiceError.authentication
        }
        
        let ref = votesRef.child("\(eventId)").child("\(user.uid)")
        ref.setValue(mark)
    }
    
    // MARK: Utility
    
    private func prepareEventDict(snap: DataSnapshot) -> [String: Any]? {
        if var dict = snap.value as? [String: Any] {
            dict[Event.CodingKeys.id.stringValue] = snap.key
            return dict
        }
        
        return nil
    }
    
}
