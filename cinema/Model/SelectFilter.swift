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
    var name: String = ""
    
    init(isOn: Bool = false, name: String) {
        self.isOn = isOn
        self.name = name
    }
}
