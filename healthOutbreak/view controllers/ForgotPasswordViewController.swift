//  ForgotPasswordViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 23/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar


class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnSubmit(_ sender:UIButton) {
        if txtEmail.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter your email", type:.error)
        } else if !txtEmail.text!.isValidEmail() {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter a valid email", type:.error)
        } else {
            self.view.endEditing(true)
            showLoader()
            APIFunc.postAPI("forget_password",["email":txtEmail.text!]) { (json,status, message) in
                DispatchQueue.main.async {
                    self.dismissLoader()
                    
                    if json.dictionary == nil {
                        return
                    }
                    
                    let status = return_status(json.dictionaryObject!)
                    
                    switch status {
                    case .success:
                        SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                        self.navigationController?.popViewController(animated:true)
                    case .fail:
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                            SwiftMessageBar.showMessage(withTitle: "Error", message:message, type:.error)
                        })
                    case .error_from_api:
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                            SwiftMessageBar.showMessage(withTitle: "Error", message:"\(json["Error from API"])", type:.error)
                        })
                    }
                }
            }
        }
    }
    
    
}
