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
    private var _votingOptions: Variable<[String]> = Variable([])
    
    // MARK: DataService protocol
    
    var events: Variable<[Event]> {
        return _events
    }
    
    var votingOptions: Variable<[String]> {
        return _votingOptions
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
        
        self.fetchVotes().subscribe(onNext: { newOptions in
            self._votingOptions.value.removeAll()
            self._votingOptions.value.append(contentsOf: newOptions)
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
    func fetchVotes() -> Observable<[String]> {
        return Observable<[String]>.create({ (observer) -> Disposable in
            let obs = self.votesRef.observe(.value, with: { (snapshot) in
                guard let _ = snapshot.value else {
                    return
                }
                
                var keys: [String] = []
                for childSnap in snapshot.children {
                    if let snap = childSnap as? DataSnapshot {
                        keys.append(snap.key)
                    } else {
                        observer.onError(DataServiceError.serialization)
                    }
                }
                
                observer.onNext(keys)
            })
            
            return Disposables.create {
                self.votesRef.removeObserver(withHandle: obs)
            }
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
            // Times received from server are +2 hours
            if let beginDate = dict[Event.CodingKeys.beginDate.stringValue] as? TimeInterval,
                let endDate = dict[Event.CodingKeys.endDate.stringValue] as? TimeInterval {
                dict[Event.CodingKeys.beginDate.stringValue] = beginDate - 2 * 3_600_000
                dict[Event.CodingKeys.endDate.stringValue] = endDate - 2 * 3_600_000
            }
            dict[Event.CodingKeys.id.stringValue] = snap.key
            return dict
        }
        
        return nil
    }
    
}
