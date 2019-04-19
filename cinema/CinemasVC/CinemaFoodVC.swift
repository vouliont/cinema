//
//  CinemaFoodVC.swift
//  cinema
//
//  Created by Владислав on 4/18/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import Alamofire

class CinemaFoodVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var foodTableView: UITableView!
    
    var cinemaId: Int!
    
    var food: [Food] = []
    
    private var foodTypes: [FoodType] = []
    
    private var getFoodTypesRequest: Alamofire.DataRequest?
    private var getFoodRequest: Alamofire.DataRequest?
    
    private let screenSize = UIScreen.main.bounds
    
    private var filterButton: UIBarButtonItem!
    private var foodFilterVC: FilterVC!
    
    private let foodFilterHeaders = [
        "Тип"
    ]
    private var foodFilterCells: [FilterCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filterButtonImg = UIImage(named: "filter")
        filterButton = UIBarButtonItem(image: filterButtonImg, style: .plain, target: self, action: #selector(openFilterButtonPressed))
        filterButton.tintColor = #colorLiteral(red: 0.8717461228, green: 0.8868257403, blue: 0.8863963485, alpha: 1)
        
        foodFilterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterVC") as? FilterVC
        foodFilterVC.didMove(toParent: self)
        self.addChild(foodFilterVC)
        foodFilterVC.bottomHeight = self.tabBarController?.tabBar.frame.height ?? 0
        
        getFoodRequest = Requests.instance.getFood(typeId: nil, cinemaId: cinemaId, completion: { (success, food) in
            self.getFoodRequest = nil
            if !success { return }
            
            if let food = food {
                self.food = food
                self.foodTableView.reloadData()
            }
        })
        
        getFoodTypesRequest = Requests.instance.getFoodTypes(completion: { success, foodTypes in
            self.getFoodTypesRequest = nil
            if !success { return }
            
            self.foodTypes = foodTypes ?? []
            
            if let foodTypes = foodTypes {
                self.foodFilterCells.append(FilterCell(identifier: "pickerCell", items: [
                    PickerFilter(items: foodTypes, selected: nil, placeholder: "Выберите тип", typeObjects: .FoodTypes)
                    ]
                ))
            }
            self.foodFilterVC.headers = self.foodFilterHeaders
            self.foodFilterVC.data = self.foodFilterCells
            self.foodFilterVC.filtersTableView.reloadData()
            self.foodFilterVC.applyButton.addTarget(self, action: #selector(self.applyFiltersButtonPressed), for: .touchUpInside)
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = filterButton
        tabBarController?.navigationItem.title = "Еда и напитки"
        
        foodFilterVC.view.bounds = self.view.bounds
        foodFilterVC.view.frame.origin.x = screenSize.width
        foodFilterVC.view.frame.origin.y = 0
        self.view.addSubview(foodFilterVC.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        foodFilterVC.toggleFilter(false)
        getFoodTypesRequest?.cancel()
    }
    
    @objc func openFilterButtonPressed() {
        foodFilterVC.toggleFilter()
    }
    
    @objc func applyFiltersButtonPressed() {
        self.view.endEditing(true)
        
        let foodType = (foodFilterCells[0].items[0] as! PickerFilter).selected as? FoodType
        
        if let typeId = foodType?.id {
            getFoodRequest = Requests.instance.getFood(typeId: typeId, cinemaId: cinemaId, completion: { success, food in
                self.getFoodRequest = nil
                if !success { return }
                
                if let food = food {
                    self.food = food
                    self.foodTableView.reloadData()
                    self.foodFilterVC.toggleFilter(false)
                }
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodCell
        
        let foodForCell = food[indexPath.row]
        
        cell.setUpCell(food: foodForCell)
        
        return cell
    }

}


class FoodCell: UITableViewCell {
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var foodCostLabel: UILabel!
    
    func setUpCell(food: Food) {
        foodNameLabel.text = food.name
        foodCostLabel.text = "\(food.cost) грн."
    }
}
