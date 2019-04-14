//
//  UserData.swift
//  cinema
//
//  Created by Владислав on 3/3/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import Foundation

class UserData {
    static var instance = UserData()
    
    var isLoggedIn: Bool {
        get {
            return self.token != nil
        }
    }
    
    private let defaults = UserDefaults.standard
    
    public private(set) var email: String? {
        get {
            return defaults.value(forKey: "userEmail") as? String
        }
        set {
            if newValue != nil {
                defaults.set(newValue, forKey: "userEmail")
            } else {
                defaults.removeObject(forKey: "userEmail")
            }
        }
    }
    
    public private(set) var token: String? {
        get {
            return defaults.value(forKey: "userToken") as? String
        }
        set {
            if newValue != nil {
                defaults.set(newValue, forKey: "userToken")
            } else {
                defaults.removeObject(forKey: "userToken")
            }
        }
    }
    
    public private(set) var name: String?
    public private(set) var city: City?
    public private(set) var accessLevel: Int?
    
    func setData(email: String, token: String) {
        self.email = email
        self.token = token
    }
    
    func setData(name: String, city: City, accessLevel: Int) {
        self.name = name
        self.city = city
        self.accessLevel = accessLevel
    }
    
    func clearData() {
        self.name = nil
        self.email = nil
        self.token = nil
        self.city = nil
        self.accessLevel = nil
    }
}
