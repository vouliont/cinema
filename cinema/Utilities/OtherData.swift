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
    
    // CITIES
    public private(set) var cities: [String] = []
    
    func addCity(_ city: String) {
        cities.append(city)
    }
    
    func clearCities() {
        cities = []
    }
    
    // CINEMAS
    public private(set) var cinemas: [Cinema] = []
    
    func addCinema(_ cinema: Cinema) {
        cinemas.append(cinema)
    }
    
    func clearCinemas() {
        cinemas = []
    }
    
    let cinemaFormats: [Any] = [
        SelectFilter(name: "2D"),
        SelectFilter(name: "3D"),
        SelectFilter(name: "4DX"),
        SelectFilter(name: "4DX 3D"),
        SelectFilter(name: "TWINS")
    ]
    
    let cinemaFiltersHeaders = [
        "Город",
        "Форматы",
        "Время"
    ]
    
    var cinemaFiltersData: [CustomCells] = [
        CustomCells(id: "pickerCell", data: [
            PickerFilter(items: [], selected: 0, placeholder: "Выберите город")
        ]),
        CustomCells(id: "selectCell", data: [
            SelectFilter(name: "2D"),
            SelectFilter(name: "3D"),
            SelectFilter(name: "4DX"),
            SelectFilter(name: "4DX 3D"),
            SelectFilter(name: "TWINS")
        ]),
        CustomCells(id: "selectCell", data: [
            SelectFilter(name: "Утро"),
            SelectFilter(name: "День"),
            SelectFilter(name: "Вечер")
        ])
    ]
}
