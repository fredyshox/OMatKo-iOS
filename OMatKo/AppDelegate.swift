//
//  AppDelegate.swift
//  OMatKo
//
//  Created by Kacper Raczy on 27.02.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import XCGLogger
import Firebase
import ViewDeck
import IQKeyboardManagerSwift

let log: XCGLogger = {
    let log: XCGLogger = XCGLogger(identifier: "omatko.logger", includeDefaultDestinations: false)
    
    let systemDestination = AppleSystemLogDestination(owner: log, identifier: "omatko.logger.systemDestination")
    systemDestination.outputLevel = .debug
    systemDestination.showDate = false
    systemDestination.showLogIdentifier = false
    systemDestination.showLineNumber = true
    systemDestination.showFunctionName = true
    systemDestination.showFileName = true
    systemDestination.showLevel = true
    
    let emojiFormatter = PrePostFixLogFormatter()
    emojiFormatter.apply(prefix: "❌ ", postfix: nil, to: .error)
    emojiFormatter.apply(prefix: "🔶 ", postfix: nil, to: .warning)
    emojiFormatter.apply(prefix: "🔷 ", postfix: nil, to: .info)
    emojiFormatter.apply(prefix: "◻️ ", postfix: nil, to: .debug)
    systemDestination.formatters = [emojiFormatter]
    
    log.add(destination: systemDestination)
    
    log.logAppDetails()
    
    return log
}()

var localDataService: LocalDataService = XMLLocalDataService()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let sideMenuManager: SideMenuManager = SideMenuManager()
    
    func setUpSideMenu() {
        let vc = self.sideMenuManager.sideMenuAdapter.container
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    private lazy var _dataService: DataService = {
        let service = FirebaseDataService()
        service.start()
        
        return service
    }()
    
    static var dataService: DataService {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate._dataService
    }
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        _ = _dataService
        
        // IQKeyboardManager
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.omatkoPrimary
        setUpSideMenu()
        
        Theme.apply()
        
        return true
    }

}

