//
//  SessionsHeaderView.swift
//  cinema
//
//  Created by Владислав on 4/16/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

@IBDesignable
class SessionsHeaderView: UICollectionReusableView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBOutlet var sessionsHeaderLabel: UILabel!
    
}
