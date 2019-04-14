//
//  FilmsVC.swift
//  cinema
//
//  Created by Владислав on 2/25/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class FilmsListVC: PopupVC, UITableViewDelegate, UITableViewDataSource {
    
    var cinemaId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

class FilmsListCell: UITableViewCell {
    
    @IBOutlet var filmImage: UIImageView!
    @IBOutlet var filmName: UILabel!
    @IBOutlet var filmGenre: UILabel!
    
    func setupCell(name: String, genre: String, image: UIImage) {
        self.filmName.text = name
        self.filmGenre.text = genre
        self.filmImage.image = image
    }
    
}
