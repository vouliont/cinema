//
//  BorderedView.swift
//  cinema
//
//  Created by Владислав on 3/3/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
