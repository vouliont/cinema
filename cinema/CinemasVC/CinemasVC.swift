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
    private var getFormatsRequest: Alamofire.DataRequest?
    
    private let cinemaFiltersHeaders = [
        "Город",
        "Форматы"
    ]
    private var cinemasFilterCells: [FilterCell] = []
    
    private let screenSize = UIScreen.main.bounds
    
    private var cinemasFilterVC: FilterVC!
    
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
        
        cinemasFilterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterVC") as? FilterVC
        cinemasFilterVC.didMove(toParent: self)
        self.addChild(cinemasFilterVC)
        
        getCitiesRequest = Requests.instance.getCities { success, cities in
            if !success { return }
            
            self.getFormatsRequest = Requests.instance.getFormats { success, formats in
                if !success { return }
                
                self.cinemasFilterCells = [
                    FilterCell(identifier: "pickerCell", items: [
                        PickerFilter(items: cities!, selected: cities!.first(where: { city -> Bool in
                            return city.id == UserData.instance.city?.id
                        }))
                    ]),
                    FilterCell(identifier: "selectCell", items: formats!.map({ format -> SelectFilter in
                            return SelectFilter(data: format);
                        })
                    )
                ]
                self.cinemasFilterVC.headers = self.cinemaFiltersHeaders
                self.cinemasFilterVC.data = self.cinemasFilterCells
                self.cinemasFilterVC.filtersTableView.reloadData()
                self.cinemasFilterVC.applyButton.addTarget(self, action: #selector(self.applyFiltersButtonPressed), for: .touchUpInside)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cinemasFilterVC.view.bounds = self.view.bounds
        cinemasFilterVC.view.frame.origin.x = screenSize.width
        cinemasFilterVC.view.frame.origin.y = 0
        self.view.addSubview(cinemasFilterVC.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getCinemasRequest?.cancel()
        getCitiesRequest?.cancel()
        getFormatsRequest?.cancel()
    }
    
    @objc func applyFiltersButtonPressed() {
        self.view.endEditing(true)
        
        let city: City = (cinemasFilterCells[0].items[0] as! PickerFilter).selected as! City
        
        var formats: [Format] = []
        cinemasFilterCells[1].items.forEach { format in
            guard let format = format as? SelectFilter else { return }
            if format.isOn {
                formats.append(format.data as! Format)
            }
        }
        
        getCinemasRequest = Requests.instance.getCinemas(city: city, formats: formats) { success in
            self.cinemasTableView.reloadData()
            self.cinemasFilterVC.toggleFilter(false)
        }
    }
    
    @objc func openFilterButtonPressed() {
        cinemasFilterVC.toggleFilter()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFilmsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

class CinemaCell: UITableViewCell {
    
    @IBOutlet var cinemaName: UILabel!
    @IBOutlet var cinemaAddress: UILabel!
    @IBOutlet var cinemaFormats: UILabel!
    
    func setUpCell(_ cinema: Cinema) {
        cinemaName.text = cinema.name
        cinemaAddress.text = cinema.address
        cinemaFormats.text = cinema.formats.map({ format -> String in
            return format.name
        }).joined(separator: ", ")
    }
}
