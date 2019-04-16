//
//  SelectFilter.swift
//  cinema
//
//  Created by Владислав on 4/13/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class SelectFilter {
    var isOn: Bool = false
    var data: Any
    var typeObjects: SelectCellFor?
    
    init(isOn: Bool = false, data: Any, typeObjects: SelectCellFor?) {
        self.isOn = isOn
        self.data = data
        self.typeObjects = typeObjects
    }
}
