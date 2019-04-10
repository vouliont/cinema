//
//  Helpers.swift
//  cinema
//
//  Created by Владислав on 3/17/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class Helpers {
    static let instance = Helpers()
    
    func showAlert(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
}
