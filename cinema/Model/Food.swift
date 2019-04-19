//
//  Food.swift
//  cinema
//
//  Created by Владислав on 4/18/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class Food {
    public private(set) var name: String
    public private(set) var cost: Int
    
    init(name: String, cost: Int) {
        self.name = name
        self.cost = cost
    }
}
