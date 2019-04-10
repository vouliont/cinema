//
//  FilmsVC.swift
//  cinema
//
//  Created by Владислав on 2/25/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class FilmsListVC: PopupVC, UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmsListCell", for: indexPath) as! FilmsListCell
        
        cell.setupCell(name: "", genre: "", ageLimit: "", image: UIImage())
        
        return cell
    }

}

class FilmsListCell: UITableViewCell {
    
    @IBOutlet var filmImage: UIImageView!
    @IBOutlet var filmName: UILabel!
    @IBOutlet var filmGenre: UILabel!
    @IBOutlet var filmAgeLimit: UILabel!
    
    func setupCell(name: String, genre: String, ageLimit: String, image: UIImage) {
        self.filmName.text = name
        self.filmGenre.text = genre
        self.filmAgeLimit.text = ageLimit
        self.filmImage.image = image
    }
    
}
