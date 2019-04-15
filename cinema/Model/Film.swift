//
//  Film.swift
//  cinema
//
//  Created by Владислав on 4/15/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class Film {
    public private(set) var id: Int
    public private(set) var name: String
    public private(set) var genres: [Genre]
    public private(set) var formats: [Format]
    
    init(id: Int, name: String, genres: [Genre], formats: [Format]) {
        self.id = id
        self.name = name
        self.genres = genres
        self.formats = formats
    }
}
