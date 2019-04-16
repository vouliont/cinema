//
//  Constants.swift
//  cinema
//
//  Created by Владислав on 4/7/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

enum SelectCellFor {
    case Format
    case Genre
    case PartOfDay
}
enum PickerCellFor {
    case Cities
}

enum PartsOfDay: String, CaseIterable {
    case morning = "Утро"
    case afternoon = "День"
    case evening = "Вечер"
    var description: String {
        get {
            switch self {
            case .morning:
                return "morning"
            case .afternoon:
                return "afternoon"
            case .evening:
                return "evening"
            }
        }
    }
}

let USER_HAS_ENTERED = "USER HAS ENTERED"
let USER_HAS_LOGGED_OUT = "USER HAS LOGGED OUT"

let SELECT_MENU_ITEM = "SELECT MENU ITEM"
