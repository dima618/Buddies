//
//  SignUpView.swift
//  Buddies
//
//  Created by Dima Ilin on 3/24/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

//TODO: SIGN UP ERROR HANDLING!!!!!!!!!!!
class SignUpView: UIViewController, UITextFieldDelegate {
    
    var passFromSignIn = String()
    var emailFromSignIn = String()
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmpassField: UITextField!
    var ref: DatabaseReference!
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("working")
        self.hideKeyboardWhenTappedAround()
        emailField.text = emailFromSignIn
        passwordField.text = passFromSignIn
        emailField.delegate = self
        lastNameField.delegate = self
        passwordField.delegate = self
        confirmpassField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        ref = Database.database().reference()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func fieldsFilled() -> Bool {
        if (firstNameField.text == "" || lastNameField.text ==  "" || emailField.text == "" || passwordField.text == "" || confirmpassField.text == "") {
            return false;
        }
        return true;
    }
    
    func passMatch() -> Bool {
        if (passwordField.text == confirmpassField.text && passwordField.text != "") {
            return true;
        }
        return false;
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if (fieldsFilled() != true) {
            let alertController = UIAlertController(title: "Buddies", message:
                    "Some info is missing", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else if (passMatch() != true) {
            let alertController = UIAlertController(title: "Buddies", message:
                "Passwords do not match", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            if let email = emailField.text, let password = passwordField.text {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if error != nil {
                        print(error)
                    } else {
                        self.ref.child("users").child(authResult!.user.uid).setValue(["First Name": self.firstNameField.text,
                                                                                      "Last Name": self.lastNameField.text])
                        

                        self.performSegue(withIdentifier: "toLocationInfo", sender: nil)
                    }
                }
               
                
            }
        }
    }
    
    func storeUserData (userID: String) {
        self.ref.child("users").child(userID).setValue(["First Name": firstNameField.text, "Last Name": lastNameField.text])
    }
    
     //Moves view up when keyboard shows up
    @objc func keyboardWillChange (notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -(keyboardRect.height/3)
        } else {
            view.frame.origin.y = 0
        }
    }
    

    //Go back to sign in view.
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
    
    //Handle what happend when return is pressed
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
            nextPressed(self);
        }
        return true
    }
    
    //TODO: Create another sign up view for address, age, image, etc.
    //TODO: Store username, full name and stuff in Firebase.
    //TODO: Create account at the end of sign up process if all info is valid.
    //TODO: Set up email verification
    //TODO: Be able to go to each field with keyboard up, and be able to see what you are typing in each field.

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
    }

}
