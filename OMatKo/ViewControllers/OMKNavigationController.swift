//
//  OMKNavigationController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 15.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit
import FirebaseAuth

class OMKNavigationController: UINavigationController {
    
    fileprivate enum AuthState: Int {
        case signedIn
        case signedOut
    }

    // MARK: Properties
    
    private var authState: AuthState = .signedOut
    
    // MARK: Initialization
    
    init() {
        let authState = Auth.auth().currentUser == nil ? AuthState.signedOut : AuthState.signedIn
        var rootVC: UIViewController
        if authState == .signedOut {
           rootVC = OMKNavigationController.createLoginVC()
        } else {
           rootVC = OMKNavigationController.createVotesVC()
        }
        
        super.init(rootViewController: rootVC)
        self.authState = authState
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: ViewController factory
    
    private static func createLoginVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Votes", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "loginVC")
    }
    
    private static func createVotesVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Votes", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "votesVC")
    }

    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attachAuthListener()
    }
    
    // MARK: Auth Listener
    
    func attachAuthListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                if self.authState != .signedIn {
                    self.setViewControllers([OMKNavigationController.createVotesVC()], animated: true)
                    self.authState = .signedIn
                }
            } else {
                if self.authState != .signedOut {
                    self.setViewControllers([OMKNavigationController.createLoginVC()], animated: true)
                    self.authState = .signedOut
                }
            }
        }
    }

}
