


//
//  ReadMoreViewController.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 17/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class ReadMoreViewController: UIViewController {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var webview:UIWebView!
    
    var strTitle = ""
    var urlReadMore = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = strTitle
        webview.loadRequest(URLRequest(url: URL (string:urlReadMore)!))
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }

    
    
}
