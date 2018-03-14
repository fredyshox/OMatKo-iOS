//
//  OMKViewController.swift
//  OMatKo
//
//  Created by Kacper Raczy on 15.03.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class OMKViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = createBarButtonItem()
    }

    @objc
    func revealMenu(sender: Any?) {
        (self.viewDeckController as? SideMenuControllerAdapter)?.revealMenu(sender: sender)
    }
    
    private func createBarButtonItem() -> UIBarButtonItem {
        let btnImage = UIImage(named: "menu_bars")
        let button = UIBarButtonItem(image: btnImage,
                                     style: .plain,
                                     target: self,
                                     action: #selector(revealMenu(sender:)))
        
        return button
    }

}
