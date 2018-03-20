//
//  Theme.swift
//  OMatKo
//
//  Created by Kacper Raczy on 27.02.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

struct Theme {
    static func apply() {
        UINavigationBar.appearance().barTintColor = UIColor.omatkoPrimary
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = UIBarStyle.black
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

extension UIColor {
    class var omatkoPrimary: UIColor {
        return UIColor.hexStringToUIColor(hex: "#0088AA")
    }
    
    class var omatkoSecondary: UIColor {
        return UIColor.hexStringToUIColor(hex: "#007D9B")
    }
    
    class var omatkoLightBackground: UIColor {
        return UIColor.hexStringToUIColor(hex: "#EBF7F9")
    }
    
    class var omatkoIndicator: UIColor {
        return UIColor.hexStringToUIColor(hex: "#BA3100")
    }
}
