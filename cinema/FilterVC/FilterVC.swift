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
    var data: [CustomCells] = []
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
        return data[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = data[indexPath.section].id
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let selectCell = cell as? SelectCell {
            let selectFilter = data[indexPath.section].data[indexPath.row] as! SelectFilter
            selectCell.setUpCell(selectFilter: selectFilter)
        }
        
        if let pickerCell = cell as? PickerCell {
            let pickerFilter = data[indexPath.section].data[indexPath.row] as! PickerFilter
            pickerCell.setUpCell(pickerFilter: pickerFilter, keyboardPicker: keyboardPicker!)
        }
        
        return cell
    }

}

class PickerCell: UITableViewCell {
    
    var filter: PickerFilter!
    var keyboardPicker: CustomPickerView!
    
    @IBOutlet var textField: UITextField!
    
    func setUpCell(pickerFilter: PickerFilter, keyboardPicker: CustomPickerView) {
        filter = pickerFilter
        self.keyboardPicker = keyboardPicker
        textField.text = filter.items[filter.selected]
        textField.inputView = keyboardPicker
        textField.attributedPlaceholder = NSAttributedString(string: pickerFilter.placeholder, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
    }
    
    @IBAction func textFieldEditingDidBegin(_ sender: UITextField) {
        keyboardPicker.textFieldBeingEdited = textField
        keyboardPicker.data = filter.items
        keyboardPicker.reloadAllComponents()
        keyboardPicker.selectRow(filter.selected, inComponent: 0, animated: false)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        filter.selected = filter.items.index(of: sender.text!) ?? filter.selected
    }
    
}

class SelectCell: UITableViewCell {
    
    var filter: SelectFilter!
    
    @IBOutlet var filterName: UILabel!
    @IBOutlet var filterSwitch: UISwitch!
    
    @IBAction func filterSwitchDidChange(_ sender: UISwitch) {
        filter.isOn = sender.isOn
    }
    
    func setUpCell(selectFilter: SelectFilter) {
        filter = selectFilter
        filterName.text = filter.name
        filterSwitch.isOn = filter.isOn
    }
    
}
