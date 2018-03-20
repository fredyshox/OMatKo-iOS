//
//  XMLLocalDataService.swift
//  OMatKo
//
//  Created by Kacper Raczy on 05.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import RxSwift

class XMLDeserialization<T: BaseModel>: NSObject, XMLParserDelegate{
    private let callback: (T) -> ()
    private let completion: (Bool, Error?) -> ()
    private let parser: XMLParser
    
    init(data: Data, callback: @escaping (T) -> (), completion: @escaping (Bool, Error?) -> ()) {
        self.callback = callback
        self.completion = completion
        self.parser = XMLParser(data: data)
        super.init()
    }
    
    deinit {
        parser.abortParsing()
    }
    
    func parse() {
        parser.delegate = self
        parser.parse()
    }
    
    // MARK: XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == T.modelName {
            if let item = T.init(dict: attributeDict) {
                 callback(item)
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion(true, nil)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completion(false, parseError)
    }
}

class XMLLocalDataService: LocalDataService {
    
    // MARK: LocalDataService
    
    func fetchPlaces() -> Observable<Place> {
        return Observable<Place>.create({ (observer) -> Disposable in
            let fileName = "places"
            var deserializer: XMLDeserialization<Place>?
            
            if let asset = NSDataAsset(name: fileName) {
                deserializer = XMLDeserialization<Place>(data: asset.data, callback: { (item) in
                    observer.onNext(item)
                }, completion: { (completed, err) in
                    if completed {
                        observer.onCompleted()
                    }
                    
                    if err != nil {
                        observer.onError(err!)
                    }
                })
                
                deserializer!.parse()
            } else {
                observer.onError(LocalDataServiceError.fileNotFound(fileName))
            }
            
            return Disposables.create {
                deserializer = nil
            }
        })
    }
    
    func fetchContacts() -> Observable<Contact> {
        return Observable<Contact>.create({ (observer) -> Disposable in
            let fileName = "contacts"
            var deserializer: XMLDeserialization<Contact>?
            if let asset = NSDataAsset(name: fileName) {
                deserializer = XMLDeserialization<Contact>(data: asset.data, callback: { (item) in
                    observer.onNext(item)
                }, completion: { (completed, err) in
                    if completed {
                        observer.onCompleted()
                    }
                    
                    if err != nil {
                        observer.onError(err!)
                    }
                })
                
                deserializer!.parse()
            } else {
                observer.onError(LocalDataServiceError.fileNotFound(fileName))
            }
            
            return Disposables.create {
                deserializer = nil
            }
        })
    }
    
    func fetchEditions() -> Observable<Edition> {
        return Observable<Edition>.create({ (observer) -> Disposable in
            let fileName = "history"
            var deserializer: XMLDeserialization<Edition>?
            
            if let asset = NSDataAsset(name: fileName) {
                deserializer = XMLDeserialization<Edition>(data: asset.data, callback: { (item) in
                    observer.onNext(item)
                }, completion: { (completed, err) in
                    if completed {
                        observer.onCompleted()
                    }
                    
                    if err != nil {
                        observer.onError(err!)
                    }
                })
                
                deserializer!.parse()
            } else {
                observer.onError(LocalDataServiceError.fileNotFound(fileName))
            }
            
            return Disposables.create {
                deserializer = nil
            }
        })
    }
}
