//
//  BorderedView.swift
//  cinema
//
//  Created by Владислав on 4/11/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedView: UIView {

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
