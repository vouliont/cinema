//
//  FilterVC.swift
//  cinema
//
//  Created by Владислав on 4/13/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class FilterVC: KeyboardVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var filtersTableView: UITableView!
    @IBOutlet var applyButton: BorderedButton!
    
    var isOpen: Bool = false
    var headers: [String] = []
    var data: [FilterCell] = []
    let screenSize = UIScreen.main.bounds
    
    private var keyboardPicker: CustomPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardPicker = CustomPickerView()
        keyboardPicker?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        keyboardPicker?.delegate = keyboardPicker
        keyboardPicker?.dataSource = keyboardPicker
    }
    
    func toggleFilter(_ state: Bool? = nil) {
        self.view.endEditing(true)
        let newState = state != nil ? state! : !isOpen
        let targetXPosition = newState ? 0 : screenSize.width
        
        isOpen = newState
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.frame.origin.x = targetXPosition
        }, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeader = TableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
        
        tableHeader.headerLabel.text = headers[section]
        
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = data[indexPath.section].identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let selectCell = cell as? SelectCell {
            let selectFilter = data[indexPath.section].items[indexPath.row] as! SelectFilter
            selectCell.setUpCell(selectFilter: selectFilter)
        }
        
        if let pickerCell = cell as? PickerCell {
            let pickerFilter = data[indexPath.section].items[indexPath.row] as! PickerFilter
            pickerCell.setUpCell(pickerFilter: pickerFilter, keyboardPicker: keyboardPicker!)
        }
        
        return cell
    }

}

class PickerCell: UITableViewCell {
    var typeObjects: PickerCellFor!
    
    var filter: PickerFilter!
    var keyboardPicker: CustomPickerView!
    var selectedItemIndex: Int = 0
    
    @IBOutlet var textField: UITextField!
    
    func setUpCell(pickerFilter: PickerFilter, keyboardPicker: CustomPickerView) {
        filter = pickerFilter
        typeObjects = filter.typeObjects
        self.keyboardPicker = keyboardPicker
        if typeObjects == .Cities {
            textField.text = (filter.selected as! City).name
            self.selectedItemIndex = (filter.items as! [City]).firstIndex(where: { city -> Bool in
                return city.id == (filter.selected as! City).id
            }) ?? 0
        } else if typeObjects == .FoodTypes {
            if let selected = filter.selected {
                textField.text = (selected as! FoodType).name
                self.selectedItemIndex = (filter.items as! [FoodType]).firstIndex(where: { foodType -> Bool in
                    return foodType.id == (selected as! FoodType).id
                }) ?? 0
            }
        } else if typeObjects == .Months {
            if let selected = filter.selected as? Int {
                textField.text = (filter.items as! [String])[selected]
            }
        }
        textField.inputView = keyboardPicker
        textField.attributedPlaceholder = NSAttributedString(string: pickerFilter.placeholder, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        keyboardPicker.textFieldBeingEdited = textField
        keyboardPicker.data = filter.items
        if typeObjects == .Cities {
            keyboardPicker.typeObjects = .Cities
        } else if typeObjects == .FoodTypes {
            keyboardPicker.typeObjects = .FoodTypes
        } else if typeObjects == .Months {
            keyboardPicker.typeObjects = .Months
            self.selectedItemIndex = filter.selected as! Int
        }
        keyboardPicker.reloadAllComponents()
        keyboardPicker.pickerDidChange = { item, index in
            if self.keyboardPicker.typeObjects == .Cities {
                self.filter.selected = item as! City
            } else if self.keyboardPicker.typeObjects == .FoodTypes {
                self.filter.selected = item as! FoodType
            } else if self.keyboardPicker.typeObjects == .Months {
                self.filter.selected = index
            }
            
            self.selectedItemIndex = index!
        }
        
        keyboardPicker.selectRow(selectedItemIndex, inComponent: 0, animated: false)
    }
    
}

class SelectCell: UITableViewCell {
    var filter: SelectFilter!
    
    @IBOutlet var filterName: UILabel!
    @IBOutlet var filterSwitch: UISwitch!
    
    var typeObjects: SelectCellFor!
    
    @IBAction func filterSwitchDidChange(_ sender: UISwitch) {
        filter.isOn = sender.isOn
    }
    
    func setUpCell(selectFilter: SelectFilter) {
        filter = selectFilter
        typeObjects = filter.typeObjects
        switch typeObjects {
        case .Format?:
            let format = filter.data as! Format
            filterName.text = format.name
        case .Genre?:
            let genre = filter.data as! Genre
            filterName.text = genre.name
        case .PartOfDay?:
            let partOfDay = filter.data as! PartsOfDay
            filterName.text = partOfDay.rawValue
        default:
            if let str = filter.data as? String {
                filterName.text = str
            } else {
                filterName.text = ""
            }
        }
        filterSwitch.isOn = filter.isOn
    }
    
}
