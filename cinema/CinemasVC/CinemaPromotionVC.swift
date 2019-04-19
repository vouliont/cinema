//
//  CinemaPromotionVC.swift
//  cinema
//
//  Created by Владислав on 4/18/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import Alamofire

class CinemaPromotionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var promotionsTableView: UITableView!
    
    var cinemaId: Int!
    
    private let screenSize = UIScreen.main.bounds
    
    private var filterButton: UIBarButtonItem!
    private var promotionFilterVC: FilterVC!
    
    private let promotionFilterHeaders = [
        "Месяц"
    ]
    private var promotionFilterCells: [FilterCell] = []
    
    private var getPromotionsRequest: Alamofire.DataRequest?
    
    private var promotions: [Promotion] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let filterButtonImg = UIImage(named: "filter")
        filterButton = UIBarButtonItem(image: filterButtonImg, style: .plain, target: self, action: #selector(openFilterButtonPressed))
        filterButton.tintColor = #colorLiteral(red: 0.8717461228, green: 0.8868257403, blue: 0.8863963485, alpha: 1)
        
        promotionFilterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterVC") as? FilterVC
        promotionFilterVC.didMove(toParent: self)
        self.addChild(promotionFilterVC)
        promotionFilterVC.bottomHeight = self.tabBarController?.tabBar.frame.height ?? 0
        promotionFilterVC.headers = promotionFilterHeaders
        let now = Date()
        let currentMonth = Calendar.current.component(.month, from: now)
        promotionFilterCells = [FilterCell(identifier: "pickerCell", items: [PickerFilter(items: months, selected: currentMonth - 1, placeholder: "Выберите месяц", typeObjects: .Months)])]
        promotionFilterVC.data = promotionFilterCells
    
        getPromotionsRequest = Requests.instance.getPromotions(cinemaId: cinemaId, monthNumber: nil, completion: { (success, promotions) in
            self.getPromotionsRequest = nil
            if !success { return }
            
            if let promotions = promotions {
                self.promotions = promotions
                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = filterButton
        tabBarController?.navigationItem.title = "Акции"
        
        promotionFilterVC.view.bounds = self.view.bounds
        promotionFilterVC.view.frame.origin.x = screenSize.width
        promotionFilterVC.view.frame.origin.y = 0
        self.view.addSubview(promotionFilterVC.view)
        promotionFilterVC.filtersTableView.reloadData()
        promotionFilterVC.applyButton.addTarget(self, action: #selector(self.applyFiltersButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        promotionFilterVC.toggleFilter(false)
        getPromotionsRequest?.cancel()
    }
    
    @objc func openFilterButtonPressed() {
        promotionFilterVC.toggleFilter()
    }
    
    @objc func applyFiltersButtonPressed() {
        view.endEditing(true)
        
        let monthNumber = (promotionFilterVC.data[0].items[0] as! PickerFilter).selected as! Int
        
        getPromotionsRequest = Requests.instance.getPromotions(cinemaId: cinemaId, monthNumber: monthNumber, completion: { (success, promotions) in
            self.getPromotionsRequest = nil
            if !success { return }
            
            if let promotions = promotions {
                self.promotions = promotions
                self.promotionsTableView.reloadData()
                self.promotionFilterVC.toggleFilter(false)
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promotionCell", for: indexPath) as! PromotionCell
        
        let promotion = promotions[indexPath.row]
        cell.setUpCell(promotion: promotion)
        
        return cell
    }
    
}

class PromotionCell: UITableViewCell {
    @IBOutlet var promotionNameLabel: UILabel!
    @IBOutlet var promotionDescriptionLabel: UILabel!
    
    func setUpCell(promotion: Promotion) {
        promotionNameLabel.text = promotion.name
        promotionDescriptionLabel.text = promotion.description
    }
}
