//
//  Requests.swift
//  cinema
//
//  Created by Владислав on 3/17/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Requests {
    static let instance = Requests()
    
    private enum Urls: String {
        case signIn = "http://localhost/v1/signin"
        case signUp = "http://localhost/v1/signup"
        case getUserData = "http://localhost/v1/getuserdata"
        case getCities = "http://localhost/v1/getcities"
    }
    private let headers: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    func signUp(name: String, email: String, password: String, city: String, completion: @escaping (_ success: Bool, _ message: String) -> Void) -> Alamofire.DataRequest {
        let params: [String: String] = [
            "name": name,
            "email": email,
            "password": password,
            "city": city
        ]
        
        let request = Alamofire.request(Urls.signUp.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion(false, "Запрос не удался.")
                return
            }
            
            guard let result = response.result.value else {
                completion(false, "Ответ сервера некоректный.")
                return
            }
            let json = JSON(result)
            
            let success = json["success"].boolValue
            let message = json["message"].stringValue
            
            completion(success, message)
        }
        
        return request
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ success: Bool, _ message: String) -> Void) -> Alamofire.DataRequest {
        let params: [String: String] = [
            "email": email,
            "password": password
        ]
        
        let request = Alamofire.request(Urls.signIn.rawValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion(false, "Запрос не удался.")
                return
            }
            
            guard let result = response.result.value else {
                completion(false, "Ответ сервера некоректный.")
                return
            }
            let json = JSON(result)
            
            let success = json["success"].boolValue
            let message = json["message"].stringValue
            
            if success {
                let token = json["token"].stringValue
                UserData.instance.setData(email: email, token: token)
            }
            
            completion(success, message)
        }
        
        return request
    }
    
    func getUserData(token: String, completion: @escaping (_ success: Bool) -> Void) -> Alamofire.DataRequest {
        var headers: [String: String] = [
            "X-Session-Token": token
        ]
        headers.merge(self.headers) { (current, _) -> String in
            current
        }
        
        let request = Alamofire.request(Urls.getUserData.rawValue, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion(false)
                return
            }
            
            guard let result = response.result.value else {
                completion(false)
                return
            }
            let json = JSON(result)
            
            let success = json["success"].boolValue
            if success {
                let name = json["name"].stringValue
                let city = json["city"].stringValue
                let accessLevel = json["accessLevel"].intValue
                
                UserData.instance.setData(name: name, city: city, accessLevel: accessLevel)
            }
            
            completion(success)
        }
        
        return request
    }
    
    func getCities(completion: @escaping (_ success: Bool) -> Void) -> Alamofire.DataRequest {
        let request = Alamofire.request(Urls.getCities.rawValue, method: .get, parameters: nil, encoding: JSONEncoding.default
            , headers: headers)
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion(false)
                return
            }
            
            guard let result = response.result.value else { return }
            let json = JSON(result)
            
            if !json["success"].boolValue {
                completion(false)
                return
            }
            
            let cities = json["cities"].arrayValue
            
            OtherData.instance.clearCities()
            for city in cities {
                OtherData.instance.addCity(city.stringValue)
            }
            completion(true)
        }
        
        return request
    }
}
