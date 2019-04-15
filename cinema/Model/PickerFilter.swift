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
    var typeObjects: PickerCellFor
    
    init(items: [Any], selected: Any?, placeholder: String = "", typeObjects: PickerCellFor) {
        self.items = items
        self.selected = selected
        self.placeholder = placeholder
        self.typeObjects = typeObjects
    }
}
