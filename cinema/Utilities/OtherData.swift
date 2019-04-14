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
    
    // CINEMAS
    public private(set) var cinemas: [Cinema] = []
    
    func addCinema(_ cinema: Cinema) {
        cinemas.append(cinema)
    }
    
    func clearCinemas() {
        cinemas = []
    }
}
