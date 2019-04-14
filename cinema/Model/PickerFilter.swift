//
//  PickerFilter.swift
//  cinema
//
//  Created by Владислав on 4/13/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class PickerFilter {
    var items: [Any]
    var selected: Any?
    var placeholder: String
    
    init(items: [Any], selected: Any?, placeholder: String = "") {
        self.items = items
        self.selected = selected
        self.placeholder = placeholder
    }
}
