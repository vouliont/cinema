//
//  PopupVC.swift
//  cinema
//
//  Created by Владислав on 2/24/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class PopupVC: UIViewController {
    
    var rootController: RevealVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonImg = UIImage(named: "burger")
        let barButton = UIBarButtonItem(image: barButtonImg, style: .plain, target: self, action: #selector(toggleSidebar))
        barButton.tintColor = #colorLiteral(red: 0.8717461228, green: 0.8868257403, blue: 0.8863963485, alpha: 1)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func toggleSidebar() {
        rootController.toggleSidebar()
    }

}
