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
        case getFilms = "http://localhost/v1/films"
        case getGenres = "http://localhost/v1/genres"
        case getFilm = "http://localhost/v1/film"
        case getSessions = "http://localhost/v1/sessions"
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
    
    func getGenres(completion: ((_ success: Bool, _ genres: [Genre]?) -> Void)?) -> Alamofire.DataRequest {
        let request = Alamofire.request(Urls.getGenres.rawValue, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        
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
            
            let jsonGenres = json["genres"].arrayValue
            
            let genres = jsonGenres.map({ jsonGenre -> Genre in
                let genre = jsonGenre.dictionaryValue
                let id = genre["id"]!.intValue
                let name = genre["name"]!.stringValue
                return Genre(id: id, name: name)
            });
            
            completion?(true, genres)
        }
        
        return request
    }
    
    func getCinemas(city: City = UserData.instance.city!, formats: [Format] = [], completion: ((_ success: Bool, _ cinemas: [Cinema]?) -> Void)?) -> Alamofire.DataRequest {
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
                completion?(false, nil)
                return
            }
            
            guard let result = response.result.value else { return }
            let json = JSON(result)
            
            if !json["success"].boolValue {
                completion?(false, nil)
                return
            }
            
            let jsonCinemas = json["cinemas"].dictionaryValue
            
            let cinemas = jsonCinemas.map({ (key: String, jsonCinema: JSON) -> Cinema in
                let id = Int(key)!
                let name = jsonCinema["name"].stringValue
                let address = jsonCinema["address"].stringValue
                let formats = jsonCinema["formats"].arrayValue.map { Format(id: $0.dictionaryValue["id"]!.intValue, name: $0.dictionaryValue["name"]!.stringValue) }
                return Cinema(id: id, name: name, address: address, formats: formats)
            })
            
            completion?(true, cinemas)
        }
        
        return request;
    }
    
    func getFilms(cinemaId: Int?, genres: [Genre] = [], partsOfDay: [PartsOfDay] = [], completion: ((_ success: Bool, _ films: [Film]?) -> Void)?) -> Alamofire.DataRequest {
        var headers: [String: String] = [
            "X-Session-Token": UserData.instance.token!
        ]
        headers.merge(self.headers) { (current, _) -> String in
            current
        }
        let genresIds = genres.map { genre -> Int in
            return genre.id
        }
        
        var params: [String: Any] = [
            "genres": genresIds
        ]
        if let cinemaId = cinemaId {
            params["cinemaId"] = cinemaId
        }
        if partsOfDay.count != 0 {
            params["partsOfDay"] = partsOfDay.map({ partOfDay -> String in
                return partOfDay.description
            })
        }
        
        let request = Alamofire.request(Urls.getFilms.rawValue, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
        
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
            
            let films: [Film] = json["films"].dictionaryValue.map({ (key: String, value: JSON) -> Film in
                let id = Int(key)!
                let name = value["name"].stringValue
                let genres: [Genre] = value["genres"].arrayValue.map({ jsonGenre -> Genre in
                    return Genre(id: jsonGenre["id"].intValue, name: jsonGenre["name"].stringValue)
                })
                let formats: [Format] = value["formats"].arrayValue.map({ jsonFormat -> Format in
                    return Format(id: jsonFormat["id"].intValue, name: jsonFormat["name"].stringValue)
                })
                return Film(id: id, name: name, genres: genres, formats: formats)
            })
            
            completion?(true, films)
        }
        
        return request
    }
    
    func getFilm(filmId: Int, completion: ((_ success: Bool, _ film: [String: Any]?) -> Void)?) -> Alamofire.DataRequest {
        var headers: [String: String] = [
            "X-Session-Token": UserData.instance.token!
        ]
        headers.merge(self.headers) { (current, _) -> String in
            current
        }
        let params: [String: Any] = [
            "filmId": filmId
        ]
        
        let request = Alamofire.request(Urls.getFilm.rawValue, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers);
        
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
            
            let jsonFilm = json["film"].dictionaryValue
            
            let film: [String: Any] = [
                "name": jsonFilm["name"]!.stringValue,
                "description": jsonFilm["description"]!.stringValue,
                "duration": jsonFilm["duration"]!.intValue,
                "director": jsonFilm["director"]!.stringValue,
                "genres": jsonFilm["genres"]!.arrayValue.map({ jsonGenre -> String in
                    return jsonGenre.stringValue
                })
            ]
            
            completion?(true, film)
        }
        
        return request
    }
    
    func getSessions(filmId: Int, cinemaId: Int?, partsOfDay: [PartsOfDay] = [], completion: ((_ success: Bool, _ sessionsHeaders: [String]?, _ sessionsData: [[Double]]?) -> Void)?) -> Alamofire.DataRequest {
        var headers: [String: String] = [
            "X-Session-Token": UserData.instance.token!
        ]
        headers.merge(self.headers) { (current, _) -> String in
            current
        }
        
        var params: [String: Any] = [
            "filmId": filmId
        ]
        if let cinemaId = cinemaId {
            params["cinemaId"] = cinemaId
        }
        if partsOfDay.count != 0 {
            params["partsOfDay"] = partsOfDay.map({ partOfDay -> String in
                return partOfDay.description
            })
        }
        
        let request = Alamofire.request(Urls.getSessions.rawValue, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
        
        request.responseJSON { response in
            if let error = response.error {
                debugPrint(error)
                completion?(false, nil, nil)
                return
            }
            
            guard let result = response.result.value else { return }
            let json = JSON(result)
            
            if !json["success"].boolValue {
                completion?(false, nil, nil)
                return
            }
            
            var sessionsHeaders: [String] = []
            var sessionsData: [[Double]] = []
            
            json["sessions"].dictionaryValue.forEach({ (key: String, value: JSON) in
                let jsonCinema = value.dictionaryValue
                sessionsHeaders.append(jsonCinema["name"]!.stringValue)
                sessionsData.append(jsonCinema["times"]!.arrayValue.map({ jsonTimes -> Double in
                    return jsonTimes.doubleValue
                }).sorted())
            })
            
            completion?(true, sessionsHeaders, sessionsData)
        }
        
        return request
    }
}
