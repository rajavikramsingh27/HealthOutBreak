//
//  privacyPolicyViewController.swift
//  healthOutbreak
//
//  Created by Ayush Pathak on 01/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class privacyPolicyViewController: UIViewController {

    @IBOutlet weak var privacyPolicyTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func agreeBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
