//
//  LocationInfoView.swift
//  Buddies
//
//  Created by Dima Ilin on 3/30/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//

import UIKit

class LocationInfoView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func locationOkPressed(_ sender: Any) {
        performSegue(withIdentifier: "toLocationAccept", sender: nil)
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
