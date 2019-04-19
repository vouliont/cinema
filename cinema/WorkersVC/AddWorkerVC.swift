//
//  AddWorkerVC.swift
//  cinema
//
//  Created by Владислав on 4/19/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class AddWorkerVC: UIViewController {
    
    var rootViewController: WorkersVC?

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var sexTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var positionTextField: UITextField!
    @IBOutlet var salaryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        let name = userNameTextField.text ?? ""
        let dateText = dateTextField.text ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = Int(dateFormatter.date(from: dateText)!.timeIntervalSince1970)
        let sex = sexTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let position = positionTextField.text ?? ""
        let salary = Int(salaryTextField.text ?? "2000") ?? 2000
        
        Requests.instance.addUser(name: name, date: date, sex: sex, phoneNumber: phoneNumber, position: position, salary: salary) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
