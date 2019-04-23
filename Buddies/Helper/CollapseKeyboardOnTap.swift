//
//  CollapseKeyboardOnTap.swift
//  Buddies
//
//  Created by Dima Ilin on 3/28/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//
import UIKit
import Foundation
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
