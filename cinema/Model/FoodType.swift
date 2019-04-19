//
//  FoodType.swift
//  cinema
//
//  Created by Владислав on 4/18/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class FoodType {
    public private(set) var id: Int
    public private(set) var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
