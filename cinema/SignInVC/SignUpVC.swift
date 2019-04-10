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
    
    private var signUpRequest: Alamofire.DataRequest?
    private var signInRequest: Alamofire.DataRequest?
    private var getUserDataRequest: Alamofire.DataRequest?
    private var getCitiesRequest: Alamofire.DataRequest?
    
    private var cityPicker: CustomPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPicker = CustomPickerView()
        cityPicker?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cityPicker?.delegate = cityPicker
        cityPicker?.dataSource = cityPicker
        cityPicker?.textFieldBeingEdited = cityField
        getCitiesRequest = Requests.instance.getCities { success in
            if success {
                self.cityPicker?.data = OtherData.instance.cities
                self.cityPicker?.reloadAllComponents()
            }
        }

        nameField.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        repeatPasswordField.attributedPlaceholder = NSAttributedString(string: "Повторите пароль", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        cityField.attributedPlaceholder = NSAttributedString(string: "Город", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        cityField.inputView = cityPicker
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        signUpRequest?.cancel()
        signInRequest?.cancel()
        getUserDataRequest?.cancel()
        getCitiesRequest?.cancel()
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard signUpRequest == nil, signInRequest == nil, getUserDataRequest == nil else { return }
        guard let name = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        guard let repeatPassword = repeatPasswordField.text else { return }
        guard let city = cityField.text else { return }
        
        view.endEditing(true)
        
        if !isUserDataValid(name: name, email: email, password: password, repeatPassword: repeatPassword, city: city, true) { return }
        
        // todo show loading indicator
        // ...
        
        signUpRequest = Requests.instance.signUp(name: name, email: email, password: password, city: city) { (success, message) in
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
                
                self.getUserDataRequest = Requests.instance.getUserData(token: UserData.instance.token!, completion: { success in
                    self.getUserDataRequest = nil
                    if success {
                        NotificationCenter.default.post(name: NSNotification.Name(USER_HAS_ENTERED), object: nil)
                        self.navigationController?.view.removeFromSuperview()
                    } else {
                        // todo hise loading indicator
                        // ...
                        Helpers.instance.showAlert(controller: self, title: "Что-то пошло не так.", message: "Повторите попытку еще раз, пожалуйста.")
                    }
                })
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
