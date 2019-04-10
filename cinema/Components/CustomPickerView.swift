//
//  CustomPickerView.swift
//  cinema
//
//  Created by Владислав on 4/10/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var data: [String] = []
    var textFieldBeingEdited: UITextField?
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldBeingEdited?.text = data[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }

}
