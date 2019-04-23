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

//TODO: Create a feed view after sign in
//TODO: Figure out how to find people nearby and display them to user
//TODO: Figure out what will happen if there are lots and lots of people around you with the app. - non issue

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailField.delegate = self
        passwordField.delegate = self
        self.hideKeyboardWhenTappedAround()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp" {
            let nav = segue.destination as! UINavigationController
            let signUp = nav.topViewController as? SignUpView
            signUp?.passFromSignIn = passwordField.text!
            signUp?.emailFromSignIn = emailField.text!
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if error != nil {
                    if let error = error as NSError? {
                        strongSelf.handleAuthErrors(error: error)
                    }
//                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                        strongSelf.performSegue(withIdentifier: "toSignUp", sender: nil)
//                    }
                } else {
                    if let UserID = Auth.auth().currentUser?.uid {
                        KeychainWrapper.standard.set(UserID, forKey: "KEY_UID")
                        strongSelf.performSegue(withIdentifier: "toFeed", sender: nil)
                    }
                }
            }
        }
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func singInGoogle(_ sender: Any) {
        
    }
    //TODO: Set first case to check for empty fields.
    func handleAuthErrors(error: NSError) {
        if emailField.text == "" && passwordField.text == "" {
            errMsg(msg: "Please Enter Login Info");
        }
        if let errorCode = AuthErrorCode(rawValue: error.code){
            switch (errorCode) {
                case .wrongPassword:
                    errMsg(msg: "Invalid or Missing Password")
                    break
                case .invalidEmail:
                    errMsg(msg: "Please Enter a Valid Email")
                    break
                case .userNotFound:
                    self.performSegue(withIdentifier: "toSignUp", sender: nil)
                    break
                default:
                    errMsg(msg: "An Error Occured")
            }
        }
        
    }
    
    
    // Helper error message function
    func errMsg(msg: String) {
        let alertController = UIAlertController(title: "Buddies", message:
            msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //Handle what happens when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.text != "" && passwordField.text == "" {
            passwordField.becomeFirstResponder()
        }
        else if emailField.text == "" && passwordField.text != "" {
            emailField.becomeFirstResponder()
        }
        else if emailField.text == "" && passwordField.text == "" {
            
        }
        else {
            signInPressed(self)
        }
        return true
    }
    
    
    
    
}

