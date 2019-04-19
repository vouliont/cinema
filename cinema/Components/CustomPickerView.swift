//
//  CustomPickerView.swift
//  cinema
//
//  Created by Владислав on 4/10/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    enum PickerViewFor {
        case Cities
        case FoodTypes
        case Months
    }
    
    var pickerDidChange: ((_ selected: Any, _ index: Int?) -> Void)?

    var data: [Any] = []
    var selected: Any?
    var textFieldBeingEdited: UITextField!
    var typeObjects: PickerViewFor!
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typeObjects == .Cities {
            let city = data[row] as! City
            textFieldBeingEdited.text = city.name
        } else if typeObjects == .FoodTypes {
            let foodType = data[row] as! FoodType
            textFieldBeingEdited.text = foodType.name
        } else if typeObjects == .Months {
            let monthName = data[row] as! String
            textFieldBeingEdited.text = monthName
        }
        selected = data[row]
        pickerDidChange?(selected!, row)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.isEmpty ? 0 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if typeObjects == .Cities {
            let city = data[row] as! City
            return city.name
        } else if typeObjects == .FoodTypes {
            let foodType = data[row] as! FoodType
            return foodType.name
        } else if typeObjects == .Months {
            let monthName = data[row] as! String
            return monthName
        }
        
        return ""
    }

}
