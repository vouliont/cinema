//
//  SignInVC.swift
//  cinema
//
//  Created by Владислав on 3/3/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit
import EmailValidator
import Alamofire

class SignInVC: KeyboardVC {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    private var signInRequest: Alamofire.DataRequest?
    private var getUserDataRequest: Alamofire.DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6156862745, green: 0.6117647059, blue: 0.6117647059, alpha: 1)])
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard signInRequest == nil, getUserDataRequest == nil else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        view.endEditing(true)
        
        if !isUserDataValid(email: email, password: password, true) { return }
        
        // todo show loading indicator
        // ...
        
        signInRequest = Requests.instance.signIn(email: email, password: password) { (success, message) in
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
    
    @IBAction func showSignUpVCButtonPressed(_ sender: Any) {
        guard getUserDataRequest == nil else { return }
        signInRequest?.cancel()
        view.endEditing(true)
        performSegue(withIdentifier: "showSignUpVC", sender: nil)
    }
    
    func isUserDataValid(email: String, password: String, _ isShowAlertIfNeeded: Bool) -> Bool {
        let title = "Данные введены неверно."
        
        if !EmailValidator.validate(email: email) {
            if isShowAlertIfNeeded { Helpers.instance.showAlert(controller: self, title: title, message: "Некоректный email.") }
            return false
        }
        
        if password.count < 6 || password.count > 50 {
            if isShowAlertIfNeeded { Helpers.instance.showAlert(controller: self, title: title, message: "Некоректный пароль.") }
            return false
        }
        
        return true
    }
}
