//
//  SignUpView.swift
//  Buddies
//
//  Created by Dima Ilin on 3/24/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//

import UIKit
import Firebase

class SignUpView: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmpassField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func fieldsFilled() -> Bool {
        if (firstNameField.text == "" || lastNameField.text ==  "" || emailField.text == "" || usernameField.text == "" || passwordField.text == "" || confirmpassField.text == "") {
            return false;
        } else{
            return true;
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if (fieldsFilled() != true) {
            let alertController = UIAlertController(title: "Buddies", message:
                    "Some info is missing", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
