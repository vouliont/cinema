//
//  Popup.swift
//  cinema
//
//  Created by Владислав on 3/3/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

struct PopupItem {
    public private(set) var name: String!
    public private(set) var id: String!
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}
