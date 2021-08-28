//  TrackViewController.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 04/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit


class TrackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
}
