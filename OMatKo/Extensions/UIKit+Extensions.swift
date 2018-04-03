//
//  UIKit+Extensions.swift
//  UtilityKit
//
//  Created by Kacper Raczy on 07.12.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit


typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint: CGPoint {
        return points.startPoint
    }
    
    var endPoint: CGPoint {
        return points.endPoint
    }
    
    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint.init(x: 0.0, y: 1.0), CGPoint.init(x: 1.0, y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 1, y: 1))
        case .horizontal:
            return (CGPoint.init(x: 0.0, y: 0.5), CGPoint.init(x: 1.0, y: 0.5))
        case .vertical:
            return (CGPoint.init(x: 0.0, y: 0.0), CGPoint.init(x: 0.0, y: 1.0))
        }
    }
}

extension UISearchBar {
    func findBarTextField() -> UITextField! {
        let contentView = self.subviews[0]
        for view in contentView.subviews {
            if let textfield = view as? UITextField {
                return textfield
            }
        }
        return nil
    }
}


extension UIView {
    //Snapshots
    func snapshotImage() -> UIImage?{
        UIGraphicsBeginImageContext(self.bounds.size)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    func snapshotView() -> UIView?{
        if let image = snapshotImage() {
            return UIImageView(image: image)
        }else {
            return nil
        }
    }
    
    //Gradients
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}


extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        var frame = self.bounds
        frame.size.height += 20 //size of status bar
        setBackgroundImage(UIImage.gradient(size: frame.size, colors: colors), for: UIBarPosition.topAttached, barMetrics: UIBarMetrics.default)
    }
}


extension UIImage {
    static func gradient(size: CGSize, colors: [UIColor]) -> UIImage? {
        let cgColors = colors.map{$0.cgColor}
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        defer {
            UIGraphicsEndImageContext()
        }
        
        let locations: [CGFloat] = [0.25, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors as CFArray, locations: locations)
            else {return nil}
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0,y:0.0), end: CGPoint(x:0.0,y:size.height), options: [])
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func from(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIColor {
    
    //Only rgb color space
    static func rgba2rgb(background: UIColor, color: UIColor) -> UIColor {
        let bgCg = background.cgColor
        let colorCg = color.cgColor
        let alpha = colorCg.alpha
        
        return UIColor(red: (1 - alpha) * bgCg.components![0] + colorCg.components![0],
                       green: (1 - alpha) * bgCg.components![1] + colorCg.components![1],
                       blue: (1 - alpha) * bgCg.components![2] + colorCg.components![2],
                       alpha: 1.0)
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIWindow {
    public var visibleViewController: UIViewController? {
        get {
            return getDeepestPresentedViewController(from: rootViewController)
        }
    }
    
    public func getDeepestPresentedViewController(from vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return getDeepestPresentedViewController(from: nc.visibleViewController)
        }else if let tbc = vc as? UITabBarController {
            return getDeepestPresentedViewController(from: tbc.selectedViewController)
        }else {
            if let pvc = vc?.presentedViewController {
                return getDeepestPresentedViewController(from: pvc)
            }else {
                return vc
            }
        }
    }
}

extension UITextView {
    public func removePadding() {
        self.textContainerInset = UIEdgeInsets.zero
        self.textContainer.lineFragmentPadding = 0.0
    }
}

extension UIApplication {
    public func open(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
