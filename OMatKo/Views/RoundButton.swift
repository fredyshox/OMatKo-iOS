//
//  RoundButton.swift
//  OMatKo
//
//  Created by Kacper Raczy on 19.02.2018.
//  Copyright © 2018 Kacper Raczy. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    @IBInspectable
    var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = UIColor.clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 0.0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowOffsetX: Double = 0.0 {
        didSet{
            setShadowOffset()
        }
    }
    
    @IBInspectable
    var shadowOffsetY: Double = 0.0 {
        didSet{
            setShadowOffset()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    private func setUp() {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        setShadowOffset()
    }
    
    private func setShadowOffset() {
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
    }

}
