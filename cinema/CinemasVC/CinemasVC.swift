//
//  CinemasVC.swift
//  cinema
//
//  Created by Владислав on 4/11/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import Alamofire

class CinemasVC: PopupVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var cinemasTableView: UITableView!
    
    private var getCinemasRequest: Alamofire.DataRequest?
    private var getCitiesRequest: Alamofire.DataRequest?
    
    private let screenSize = UIScreen.main.bounds
    
    private var filterViewController: FilterVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButtonImg = UIImage(named: "filter")
        let filterButton = UIBarButtonItem(image: filterButtonImg, style: .plain, target: self, action: #selector(openFilterButtonPressed))
        filterButton.tintColor = #colorLiteral(red: 0.8717461228, green: 0.8868257403, blue: 0.8863963485, alpha: 1)
        self.navigationItem.rightBarButtonItem = filterButton

        getCinemasRequest = Requests.instance.getCinemas { success in
            // check is user entered (pass param fot this case from server)
            // if user has not entered, clear user data and show signIn view
            // write function for this goal
            
            self.cinemasTableView.reloadData()
            
            self.getCinemasRequest = nil
        }
        
        filterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterVC") as? FilterVC
        filterViewController.didMove(toParent: self)
        self.addChild(filterViewController)
        
        getCitiesRequest = Requests.instance.getCities { success in
            if !success { return }
            
            let pickerFilter = OtherData.instance.cinemaFiltersData[0].data[0] as! PickerFilter
            pickerFilter.items = OtherData.instance.cities
            pickerFilter.selected = pickerFilter.items.index(of: UserData.instance.city!) ?? 0
            
            self.filterViewController.headers = OtherData.instance.cinemaFiltersHeaders
            self.filterViewController.data = OtherData.instance.cinemaFiltersData
            self.filterViewController.filtersTableView.reloadData()
            self.filterViewController.applyButton.addTarget(self, action: #selector(self.applyFiltersButtonPressed), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(filterViewController.view)
        filterViewController.view.frame.origin.x = screenSize.width
        filterViewController.view.bounds = self.view.bounds
        filterViewController.view.frame.origin.y = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getCinemasRequest?.cancel()
        getCitiesRequest?.cancel()
    }
    
    @objc func applyFiltersButtonPressed() {
        self.view.endEditing(true)
        let cityPickerFilter: PickerFilter = OtherData.instance.cinemaFiltersData[0].data[0] as! PickerFilter
        let city = cityPickerFilter.items[cityPickerFilter.selected]
        
        var formats: [String] = []
        OtherData.instance.cinemaFiltersData[1].data.forEach { format in
            guard let format = format as? SelectFilter else { return }
            if format.isOn {
                formats.append(format.name)
            }
        }
        
        getCinemasRequest = Requests.instance.getCinemas(city: city, formats: formats) { success in
            self.cinemasTableView.reloadData()
            self.filterViewController.toggleFilter(false)
        }
    }
    
    @objc func openFilterButtonPressed() {
        filterViewController.toggleFilter()
    }
    
    // UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OtherData.instance.cinemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cinemaCell", for: indexPath) as! CinemaCell
        
        let cinema = OtherData.instance.cinemas[indexPath.row]
        cell.setUpCell(cinema)
        
        return cell
    }

}

class CinemaCell: UITableViewCell {
    
    @IBOutlet var cinemaName: UILabel!
    @IBOutlet var cinemaAddress: UILabel!
    @IBOutlet var cinemaFormats: UILabel!
    
    func setUpCell(_ cinema: Cinema) {
        cinemaName.text = cinema.name
        cinemaAddress.text = cinema.address
        cinemaFormats.text = cinema.formats.joined(separator: ", ")
    }
}
