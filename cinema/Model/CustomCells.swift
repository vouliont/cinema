//
//  CustomCell.swift
//  cinema
//
//  Created by Владислав on 4/13/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class CustomCells {
    public private(set) var id: String
    public private(set) var data: [Any]
    
    init(id: String, data: [Any]) {
        self.id = id
        self.data = data
    }
}
