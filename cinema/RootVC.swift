//
//  ViewController.swift
//  cinema
//
//  Created by Владислав on 2/23/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    
    @IBOutlet var topView: UIView!
    
    private var sidebarMenuVC: SidebarMenuVC?
    private var revealVC: RevealVC?
    private var signInNavVC: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        signInNavVC = storyboard.instantiateViewController(withIdentifier: "signInNavVC") as? UINavigationController
        signInNavVC!.didMove(toParent: self)
        self.addChild(signInNavVC!)
        
        revealVC = storyboard.instantiateViewController(withIdentifier: "revealVC") as? RevealVC
        revealVC!.didMove(toParent: self)
        self.addChild(revealVC!)
        self.view.insertSubview(revealVC!.view, belowSubview: topView)
        
        sidebarMenuVC = storyboard.instantiateViewController(withIdentifier: "sidebarMenuVC") as? SidebarMenuVC
        sidebarMenuVC!.didMove(toParent: self)
        self.addChild(sidebarMenuVC!)
        self.view.insertSubview(sidebarMenuVC!.view, belowSubview: revealVC!.view)
        
        if UserData.instance.isLoggedIn {
            Requests.instance.getUserData(token: UserData.instance.token!) { success in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name(USER_HAS_ENTERED), object: nil)
                } else {
                    self.showSignInNavVC()
                }
                
                self.topView.removeFromSuperview()
            }
        } else {
            showSignInNavVC()
            topView.removeFromSuperview()
        }
    }
    
    func showSignInNavVC() {
        self.view.addSubview(signInNavVC!.view)
    }

}

