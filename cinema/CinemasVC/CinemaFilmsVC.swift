//
//  CinemaFilmsVC.swift
//  cinema
//
//  Created by Владислав on 4/14/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class CinemaFilmsVC: UIViewController {
    
    var cinemaId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        let filmsVC = UIStoryboard(name: "Films", bundle: nil).instantiateViewController(withIdentifier: "filmsVC") as! FilmsListVC
        filmsVC.didMove(toParent: self)
        filmsVC.cinemaId = cinemaId
        self.addChild(filmsVC)
        self.view.addSubview(filmsVC.view)
    }

}
