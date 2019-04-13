//
//  TableHeaderView.swift
//  cinema
//
//  Created by Владислав on 4/13/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var headerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("TableHeader", owner: self, options: nil)
        contentView.fixInView(self)
    }

}
