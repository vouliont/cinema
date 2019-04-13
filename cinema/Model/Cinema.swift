//
//  Cinema.swift
//  cinema
//
//  Created by Владислав on 4/11/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class Cinema {
    public private(set) var id: Int!
    public private(set) var name: String!
    public private(set) var address: String!
    public private(set) var formats: [String]!
    
    init(id: Int, name: String, address: String, formats: [String]) {
        self.id = id
        self.name = name
        self.address = address
        self.formats = formats
    }
}
