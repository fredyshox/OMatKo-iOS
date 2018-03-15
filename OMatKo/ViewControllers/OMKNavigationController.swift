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
    
    private var authState: AuthState = .signedOut // default value
    
    // MARK: Initialization
    
    init() {
        super.init(rootViewController: createLoginVC())
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: ViewController factory
    
    private func createLoginVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Votes", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "loginVC")
    }
    
    private func createVotesVC() -> UIViewController {
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
                    self.setViewControllers([self.createVotesVC()], animated: true)
                    self.authState = .signedIn
                }
            } else {
                if self.authState != .signedOut {
                    self.setViewControllers([self.createLoginVC()], animated: true)
                    self.authState = .signedOut
                }
            }
        }
    }

}
