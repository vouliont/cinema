//
//  CustomCell.swift
//  cinema
//
//  Created by Владислав on 4/13/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class FilterCell {
    public private(set) var identifier: String
    public private(set) var items: [Any]
    
    init(identifier: String, items: [Any]) {
        self.identifier = identifier
        self.items = items
    }
}
