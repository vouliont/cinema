//
//  PartOfDay.swift
//  cinema
//
//  Created by Владислав on 4/15/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class PartOfDay {
    public private(set) var id: Int
    public private(set) var partOfDay: PartsOfDay
    
    init(id: Int, partOfDay: PartsOfDay) {
        self.id = id
        self.partOfDay = partOfDay
    }
}
