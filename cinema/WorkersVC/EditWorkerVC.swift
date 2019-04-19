//
//  EditWorkerVC.swift
//  cinema
//
//  Created by Владислав on 4/19/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class EditWorkerVC: UIViewController {
    
    var phoneNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        Requests.instance.deleteWorker(phoneNumber: phoneNumber) { (success) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
