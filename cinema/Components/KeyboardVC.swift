//
//  KeyboardVC.swift
//  cinema
//
//  Created by Владислав on 4/7/19.
//  Copyright © 2019 vladporaiko. All rights reserved.
//

import UIKit

class KeyboardVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint?
    
    var bottomHeight: CGFloat = 0
    
    private var isLoadingFirstTime = true
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            self.reposition()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reposition()
    }
    
    private func reposition() {
        if scrollView != nil {
            repositionScrollView()
        } else {
            repositionContentView()
        }
    }
    
    private func repositionScrollView() {
        let viewportHeight = view.safeAreaLayoutGuide.layoutFrame.height - keyboardHeight
        let contentHeight = contentView.frame.height
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        let center: CGFloat = contentHeight > viewportHeight ? 0 : (viewportHeight - contentHeight) / 2
        
        scrollView!.contentInset = inset
        scrollView!.scrollIndicatorInsets = inset
        
        contentViewTopConstraint!.constant = center
        if UIView.areAnimationsEnabled && !isLoadingFirstTime {
            UIView.animate(withDuration: 0.2) {
                self.scrollView!.layoutIfNeeded()
            }
            return
        }
        
        isLoadingFirstTime = false
    }
    
    private func repositionContentView() {
        contentViewBottomConstraint!.constant = max(0, keyboardHeight - bottomHeight)
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: 0.2) {
                self.contentView.superview!.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).size
        self.keyboardHeight = keyboardSize.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.keyboardHeight = 0
    }

}
