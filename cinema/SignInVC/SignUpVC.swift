//
//  SignUpVC.swift
//  cinema
//
//  Created by Владислав on 3/3/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import EmailValidator
import Alamofire

class SignUpVC: KeyboardVC {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var repeatPasswordField: UITextField!
    @IBOutlet var cityField: UITextField!
    
    private var selectedCity: City?
    private var cities: [City]?
    
    private var signUpRequest: Alamofire.DataRequest?
    private var signInRequest: Alamofire.DataRequest?
    private var getUserDataRequest: Alamofire.DataRequest?
    private var getCitiesRequest: Alamofire.DataRequest?
    
    private var cityPickerView: CustomPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPickerView = CustomPickerView()
        cityPickerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cityPickerView?.delegate = cityPickerView
        cityPickerView?.dataSource = cityPickerView
        cityPickerView?.textFieldBeingEdited = cityField
        cityPickerView?.typeObjects = .Cities
        cityPickerView?.pickerDidChange = { city, index in
            self.selectedCity = city as? City
        }
        
        getCitiesRequest = Requests.instance.getCities { success, cities in
            if success {
                self.cities = cities!
                self.cityPickerView?.data = cities!
                self.cityPickerView?.reloadAllComponents()
            }
        }

        nameField.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        repeatPasswordField.attributedPlaceholder = NSAttributedString(string: "Повторите пароль", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        cityField.attributedPlaceholder = NSAttributedString(string: "Город", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        
        cityField.inputView = cityPickerView
        
        let backButtonImg = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: backButtonImg, style: .plain, target: self, action: #selector(popSignUp))
        backButton.tintColor = #colorLiteral(red: 0.8735373616, green: 0.8786564469, blue: 0.8784019351, alpha: 1)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        signUpRequest?.cancel()
        signInRequest?.cancel()
        getUserDataRequest?.cancel()
        getCitiesRequest?.cancel()
    }
    
    @objc func popSignUp() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard signUpRequest == nil, signInRequest == nil, getUserDataRequest == nil else { return }
        guard let name = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        guard let repeatPassword = repeatPasswordField.text else { return }
        guard let cityName = cityField.text else { return }
        
        view.endEditing(true)
        
        if !isUserDataValid(name: name, email: email, password: password, repeatPassword: repeatPassword, city: cityName, true) { return }
        
        // todo show loading indicator
        // ...
        
        signUpRequest = Requests.instance.signUp(name: name, email: email, password: password, city: selectedCity!) { (success, message) in
            self.signUpRequest = nil
            if !success {
                // todo hide loading indicator
                // ...
                Helpers.instance.showAlert(controller: self, title: "Что-то пошло не так.", message: message)
                return
            }
            
            self.signInRequest = Requests.instance.signIn(email: email, password: password) { (success, message) in
                self.signInRequest = nil
                if !success {
                    // todo hide loading indicator
                    // ...
                    Helpers.instance.showAlert(controller: self, title: "Что-то пошло не так.", message: message)
                    return
                }
                
                self.getUserDataRequest = Requests.instance.getUserData { success in
                    self.getUserDataRequest = nil
                    if success {
                        NotificationCenter.default.post(name: NSNotification.Name(USER_HAS_ENTERED), object: nil)
                        self.navigationController?.view.removeFromSuperview()
                    } else {
                        // todo hise loading indicator
                        // ...
                        Helpers.instance.showAlert(controller: self, title: "Что-то пошло не так.", message: "Повторите попытку еще раз, пожалуйста.")
                    }
                }
            }
        }
    }
    
    private func isUserDataValid(name: String, email: String, password: String, repeatPassword: String, city: String, _ isShowAlertIfNeeded: Bool) -> Bool {
        let title = "Данные введены неверно."
        
        if name.count < 2 || name.count > 30 {
            if isShowAlertIfNeeded { Helpers.instance.showAlert(controller: self, title: title, message: "Некоректное имя пользователя.") }
            return false
        }
        
        if !EmailValidator.validate(email: email) {
            if isShowAlertIfNeeded { Helpers.instance.showAlert(controller: self, title: title, message: "Некоректный email.") }
            return false
        }
        
        if password.count < 6 || password.count > 50 {
            if isShowAlertIfNeeded { Helpers.instance.showAlert(controller: self, title: title, message: "Некоректный пароль.") }
            return false
        }
        
        if password != repeatPassword {
            if isShowAlertIfNeeded { Helpers.instance.showAlert(controller: self, title: title, message: "Пароли не совпадают.") }
            return false
        }
        
        if city == "" {
            if isShowAlertIfNeeded { Helpers.instance.showAlert(controller: self, title: title, message: "Выберите, пожалуйста, город.") }
            return false
        }
        
        return true
    }
    
}
