//
//  CinemaFilmsVC.swift
//  cinema
//
//  Created by Владислав on 4/14/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class CinemaFilmsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let filmsVC = UIStoryboard(name: "Films", bundle: nil).instantiateViewController(withIdentifier: "filmsVC")
        filmsVC.didMove(toParent: self)
        self.addChild(filmsVC)
        self.view.addSubview(filmsVC.view)
    }

}
