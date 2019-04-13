//
//  SidebarMenuVC.swift
//  cinema
//
//  Created by Владислав on 2/24/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class SidebarMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    private var popupItems: [PopupItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: Notification.Name(USER_HAS_ENTERED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(USER_HAS_LOGGED_OUT), object: nil)
    }
    
    @objc func reloadTableView(_ notification: Notification) {
        updatePopupItems()
        tableView.reloadData()
        if popupItems.count > 0 {
            let index = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: index, animated: false, scrollPosition: .top)
            tableView(tableView, didSelectRowAt: index)
        }
    }
    
    @objc func updatePopupItems() {
        if !UserData.instance.isLoggedIn {
            popupItems = []
            return
        }
        popupItems = [
            PopupItem(name: "Кинотеатры", id: "cinemasNavVC"),
            PopupItem(name: "Фильмы", id: "filmsNavVC"),
//            PopupItem(name: "Акции", id: "promotionsNavVC"),
//            PopupItem(name: "Настройки", id: "settingsNavVC")
        ]
        
        if UserData.instance.accessLevel != 0 {
            // add some items like USERS, PERSONAL ...
//            popupItems.append()
        }
    }
    
    // TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popupItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sidebarMenuCell", for: indexPath) as! SidebarMenuCell
        let name = popupItems[indexPath.row].name!
        let id = popupItems[indexPath.row].id!
        cell.setupView(name: name, id: id)
        
        if indexPath.row == popupItems.count - 1 {
            cell.separator.removeFromSuperview()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = popupItems[indexPath.row].id!
        
        NotificationCenter.default.post(name: NSNotification.Name(SELECT_MENU_ITEM), object: id)
    }
    
}

class SidebarMenuCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var separator: UIView!
    
    var id: String!
    
    func setupView(name: String, id: String) {
        self.name.text = name
        self.id = id
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.layer.backgroundColor = selected ? #colorLiteral(red: 0.107949473, green: 0.1179771051, blue: 0.1177764311, alpha: 1) : UIColor.clear.cgColor
    }
}
