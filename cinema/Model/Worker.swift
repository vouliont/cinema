//
//  Worker.swift
//  cinema
//
//  Created by Владислав on 4/19/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class Worker {
    public private(set) var name: String
    public private(set) var date: Int
    public private(set) var sex: String
    public private(set) var phoneNumber: String
    public private(set) var position: String
    
    init(name: String, date: Int, sex: String, phoneNumber: String, position: String) {
        self.name = name
        self.date = date
        self.sex = sex
        self.phoneNumber = phoneNumber
        self.position = position
    }
}
