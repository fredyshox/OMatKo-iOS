//
//  RoundedImageView.swift
//  Train-Gain
//
//  Created by Kacper Raczy on 21.06.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadowColor:UIColor = UIColor.clear {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffsetX: Double = 0.0 {
        didSet{
            setShadowOffset()
        }
    }
    
    @IBInspectable var shadowOffsetY: Double = 0.0 {
        didSet{
            setShadowOffset()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            createMask()
        }
    }
    
    private func setShadowOffset() {
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
    }

    override func awakeFromNib() {
        createMask()
    }
    
    func createMask() {
        self.layer.cornerRadius = cornerRadius
    }

}
