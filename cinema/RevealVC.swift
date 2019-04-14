//
//  RevealVC.swift
//  cinema
//
//  Created by Владислав on 2/24/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class RevealVC: UIViewController {

    private var popups: [String: UINavigationController] = [:]
    private var currentPopupId: String?
    private var isSidebarOpen: Bool = false
    
    private var topShadowView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topShadowView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        topShadowView.backgroundColor = #colorLiteral(red: 0.107949473, green: 0.1179771051, blue: 0.1177764311, alpha: 0.2029644692)
        topShadowView.layer.zPosition = 20
        self.view.addSubview(topShadowView)
        topShadowView.isHidden = true
        topShadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedRevealVC)))
        
        self.view.layer.shadowOpacity = 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(togglePopup(_:)), name: NSNotification.Name(SELECT_MENU_ITEM), object: nil)
    }
    
    @objc func clickedRevealVC() {
        toggleSidebar(false)
    }
    
    func toggleSidebar(_ state: Bool? = nil) {
        self.view.endEditing(true)
        let newState = state != nil ? state! : !isSidebarOpen
        if newState == isSidebarOpen { return }
        isSidebarOpen = newState
        let targetPosition: CGFloat = newState ? self.view.frame.width - 60 : 0
        
        topShadowView.isHidden = !isSidebarOpen
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.frame.origin.x = targetPosition
        }, completion: nil)
    }
    
    @objc func togglePopup(_ notification: Notification) {
        let id = notification.object as! String
        
        if id == currentPopupId {
            toggleSidebar(false)
            return
        }
        if let currentPopupId = currentPopupId {
            popups[currentPopupId]?.view.removeFromSuperview()
            popups[currentPopupId]?.removeFromParent()
        }
        
        let popup: UINavigationController!
        
        if popups[id] == nil {
            popup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? UINavigationController
            popup.didMove(toParent: self)
            popups[id] = popup
        } else {
            popup = popups[id]
        }
        self.addChild(popup)
        self.view.insertSubview(popup.view, at: 0)
        let topViewController = popup.topViewController as! PopupVC
        topViewController.rootController = self
        currentPopupId = id
        
        toggleSidebar(false)
    }
    
}
