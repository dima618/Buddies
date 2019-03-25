//
//  ViewController.swift
//  Buddies
//
//  Created by Dima Ilin on 3/23/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
     }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if error != nil {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        strongSelf.performSegue(withIdentifier: "toSignUp", sender: nil)
                    }
                    
                } else {
                    if let UserID = Auth.auth().currentUser?.uid {
                        KeychainWrapper.standard.set(UserID, forKey: "KEY_UID")
                        strongSelf.performSegue(withIdentifier: "toFeed", sender: nil)
                    }
                }
            }
        }
        
    }
    
    @IBAction func singInGoogle(_ sender: Any) {
        
    }
    
    
    
}

