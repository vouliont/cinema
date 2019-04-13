//
//  PickerFilter.swift
//  cinema
//
//  Created by Владислав on 4/13/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class PickerFilter {
    var items: [String]
    var selected: Int
    var placeholder: String
    
    init(items: [String], selected: Int = 0, placeholder: String = "") {
        self.items = items
        self.selected = selected
        self.placeholder = placeholder
    }
}
