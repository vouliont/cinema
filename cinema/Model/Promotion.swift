//
//  Promotion.swift
//  cinema
//
//  Created by Владислав on 4/18/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class Promotion {
    public private(set) var id: Int
    public private(set) var name: String
    public private(set) var description: String
    
    init(id: Int, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}
