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
        case getCities = "http://localhost/v1/cities"
        case getFormats = "http://localhost/v1/formats"
        case getCinemas = "http://localhost/v1/cinemas"
    }
    private let headers: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    func signUp(name: String, email: String, password: String, city: City, completion: @escaping (_ success: Bool, _ message: String) -> Void) -> Alamofire.DataRequest {
        let params: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "cityId": city.id
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
    
    func getUserData(completion: @escaping (_ success: Bool) -> Void) -> Alamofire.DataRequest {
        var headers: [String: String] = [
            "X-Session-Token": UserData.instance.token!
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
                let city = City(id: json["cityId"].intValue, name: json["cityName"].stringValue)
                let accessLevel = json["accessLevel"].intValue
                
                UserData.instance.setData(name: name, city: city, accessLevel: accessLevel)
            }
            
            completion(success)
        }
        
        return request
    }
    
    func getCities(completion: ((_ success: Bool, _ cities: [City]?) -> Void)?) -> Alamofire.DataRequest {
        let request = Alamofire.request(Urls.getCities.rawValue, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion?(false, nil)
                return
            }
            
            guard let result = response.result.value else { return }
            let json = JSON(result)
            
            if !json["success"].boolValue {
                completion?(false, nil)
                return
            }
            
            let jsonCities = json["cities"].arrayValue
            
            let cities = jsonCities.map({ jsonCity -> City in
                let city = jsonCity.dictionaryValue
                let id = city["id"]!.intValue
                let name = city["name"]!.stringValue
                return City(id: id, name: name)
            });
            
            completion?(true, cities)
        }
        
        return request
    }
    
    func getFormats(completion: ((_ success: Bool, _ formats: [Format]?) -> Void)?) -> Alamofire.DataRequest {
        let request = Alamofire.request(Urls.getFormats.rawValue, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion?(false, nil)
                return
            }
            
            guard let result = response.result.value else { return }
            let json = JSON(result)
            
            if !json["success"].boolValue {
                completion?(false, nil)
                return
            }
            
            let jsonFormats = json["formats"].arrayValue
            
            let formats = jsonFormats.map({ jsonFormat -> Format in
                let format = jsonFormat.dictionaryValue
                let id = format["id"]!.intValue
                let name = format["name"]!.stringValue
                return Format(id: id, name: name)
            });
            
            completion?(true, formats)
        }
        
        return request
    }
    
    func getCinemas(city: City = UserData.instance.city!, formats: [Format] = [], completion: ((_ success: Bool) -> Void)?) -> Alamofire.DataRequest {
        var headers: [String: String] = [
            "X-Session-Token": UserData.instance.token!
        ]
        headers.merge(self.headers) { (current, _) -> String in
            current
        }
        let formatsIds = formats.map { format -> Int in
            return format.id
        }
        let params: Parameters = [
            "cityId": city.id,
            "formats": formatsIds
        ]
        
        let request = Alamofire.request(Urls.getCinemas.rawValue, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers);
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion?(false)
                return
            }
            
            guard let result = response.result.value else { return }
            let json = JSON(result)
            
            if !json["success"].boolValue {
                completion?(false)
                return
            }
            
            let cinemas = json["cinemas"].dictionaryValue
            OtherData.instance.clearCinemas()
            for (idString, cinema) in cinemas {
                let id = Int(idString)!
                let name = cinema["name"].stringValue
                let address = cinema["address"].stringValue
                let formats = cinema["formats"].arrayValue.map { Format(id: $0.dictionaryValue["id"]!.intValue, name: $0.dictionaryValue["name"]!.stringValue) }
                
                let cinemaObject = Cinema(id: id, name: name, address: address, formats: formats)
                OtherData.instance.addCinema(cinemaObject)
            }
            
            completion?(true)
        }
        
        return request;
    }
}
