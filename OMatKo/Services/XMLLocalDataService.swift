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
    private let queue: DispatchQueue
    
    var customHandler: ((String, [String: String]) -> T?)?
    
    init(data: Data, callback: @escaping (T) -> (), completion: @escaping (Bool, Error?) -> (), queue: DispatchQueue = DispatchQueue.main) {
        self.callback = callback
        self.completion = completion
        self.parser = XMLParser(data: data)
        self.queue = queue
        super.init()
    }
    
    deinit {
        queue.sync {
            parser.abortParsing()
        }
    }
    
    func parse() {
        queue.sync {
            parser.delegate = self
            parser.parse()
        }
    }
    
    // MARK: XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if customHandler != nil {
            if let item = customHandler!(elementName, attributeDict) {
                callback(item)
            }
        } else {
            if elementName == T.modelName {
                if let item = T.init(dict: attributeDict) {
                    callback(item)
                }
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
    
    private let queue: DispatchQueue = DispatchQueue(label: "com.raczy.XMLLocalDataServiceQueue", qos: .userInitiated)
    
    // MARK: LocalDataService
    
    func fetchPlaces() -> Observable<Place> {
        return Observable<Place>.create({ (observer) -> Disposable in
            
            let fileName = "places_data"
            var deserializer: XMLDeserialization<Place>?
            
            if let asset = NSDataAsset(name: fileName) {
                deserializer = XMLDeserialization<Place>(data: asset.data, callback: { (item) in
                    DispatchQueue.main.async { observer.onNext(item) }
                }, completion: { (completed, err) in
                    DispatchQueue.main.async {
                        if completed {
                            observer.onCompleted()
                        }
                            
                        if err != nil {
                            observer.onError(err!)
                        }
                    }
                }, queue: self.queue)
                    
                deserializer!.parse()
            } else {
                DispatchQueue.main.async {
                    observer.onError(LocalDataServiceError.fileNotFound(fileName))
                }
            }
            
            return Disposables.create {
                deserializer = nil
            }
        })
    }
    
    func fetchContacts() -> Observable<Contact> {
        return Observable<Contact>.create({ (observer) -> Disposable in
            let fileName = "contacts_data"
            var deserializer: XMLDeserialization<Contact>?
            
            if let asset = NSDataAsset(name: fileName) {
                deserializer = XMLDeserialization<Contact>(data: asset.data, callback: { (item) in
                    DispatchQueue.main.async { observer.onNext(item) }
                }, completion: { (completed, err) in
                    DispatchQueue.main.async {
                        if completed {
                            observer.onCompleted()
                        }
                            
                        if err != nil {
                            observer.onError(err!)
                        }
                    }
                }, queue: self.queue)
                    
                deserializer!.parse()
            } else {
                DispatchQueue.main.async {
                    observer.onError(LocalDataServiceError.fileNotFound(fileName))
                }
            }
            
            return Disposables.create {
                deserializer = nil
            }
        })
    }
    
    func fetchEditions() -> Observable<Edition> {
        return Observable<Edition>.create({ (observer) -> Disposable in
            let fileName = "history_data"
            var deserializer: XMLDeserialization<Edition>?
            
            if let asset = NSDataAsset(name: fileName) {
                deserializer = XMLDeserialization<Edition>(data: asset.data, callback: { (item) in
                    DispatchQueue.main.async { observer.onNext(item) }
                }, completion: { (completed, err) in
                    DispatchQueue.main.async {
                        if completed {
                            observer.onCompleted()
                        }
                            
                        if err != nil {
                            observer.onError(err!)
                        }
                    }
                }, queue: self.queue)
                    
                deserializer!.parse()
            } else {
                DispatchQueue.main.async {
                    observer.onError(LocalDataServiceError.fileNotFound(fileName))
                }
            }
            
            return Disposables.create {
                deserializer = nil
            }
        })
    }
    
    func fetchSponsors() -> Observable<Sponsor> {
        return Observable<Sponsor>.create({ (observer) -> Disposable in
            let fileName = "sponsors_data"
            var deserializer: XMLDeserialization<Sponsor>?
            
            if let asset = NSDataAsset(name: fileName) {
                deserializer = XMLDeserialization<Sponsor>(data: asset.data, callback: { (item) in
                    DispatchQueue.main.async { observer.onNext(item) }
                }, completion: { (completed, err) in
                    DispatchQueue.main.async {
                        if completed {
                            observer.onCompleted()
                        }
                        
                        if err != nil {
                            observer.onError(err!)
                        }
                    }
                }, queue: self.queue)
                    
                let categoryStringArr = Sponsor.Category.allValues.map({ (category) -> String in
                    return category.rawValue
                })
                    
                deserializer!.customHandler = { (elementName, attrDict) in
                    if categoryStringArr.contains(elementName) {
                        var mutableAttrDict = attrDict
                        mutableAttrDict["category"] = elementName
                        return Sponsor(dict: mutableAttrDict)
                    } else {
                        return nil
                    }
                }
                    
                deserializer!.parse()
            } else {
                DispatchQueue.main.async { observer.onError(LocalDataServiceError.fileNotFound(fileName)) }
            }
            
            return Disposables.create {
                deserializer = nil
            }
        })
    }
}
