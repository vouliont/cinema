//
//  Data.swift
//  cinema
//
//  Created by Владислав on 4/10/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class OtherData {
    static var instance = OtherData()
    
    public private(set) var cities: [String] = []
    
    func addCity(_ city: String) {
        cities.append(city)
    }
    
    func clearCities() {
        cities = []
    }
}
