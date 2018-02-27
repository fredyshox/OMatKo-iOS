//
//  RoundView.swift
//  ChineseCheckers iOS
//
//  Created by Kacper Raczy on 07.01.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

/**
 UIView with rounded corners.
 */

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable
    var shadowRadius: CGFloat = RoundViewDefaults.shadowRadius {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = RoundViewDefaults.shadowColor {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = RoundViewDefaults.shadowOpacity {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = RoundViewDefaults.cornerRadius {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = RoundViewDefaults.borderWidth {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = RoundViewDefaults.borderColor {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUp()
    }

}

fileprivate struct RoundViewDefaults {
    static let cornerRadius: CGFloat = 20.0
    static let borderWidth: CGFloat = 0.0
    static let borderColor: UIColor = UIColor.clear
    static let shadowRadius: CGFloat = 2.0
    static let shadowColor: UIColor = UIColor.black
    static let shadowOpacity: Float = 0.25
}
