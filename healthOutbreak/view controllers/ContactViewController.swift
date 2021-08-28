//  ContactViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 07/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar


class ContactViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtDescription:UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtName.text = signUp!.userName
        txtEmail.text = signUp!.userEmail
        
        if !signUp!.userName.isEmpty {
            txtName.isUserInteractionEnabled = false
            txtName.textColor = UIColor.gray
        }
        
        if !signUp!.userEmail.isEmpty {
            txtEmail.isUserInteractionEnabled = false
            txtEmail.textColor = UIColor.gray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender:UIButton) {
        if txtName.text!.isEmpty {
        SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter your name", type:.error)
        } else if txtEmail.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter your email address", type:.error)
        } else if !txtEmail.text!.isValidEmail() {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter a valid email", type:.error)
        } else if txtDescription.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter what do you want to tell us about ?", type:.error)
        } else {
            keep_in_touch()
        }
        
    }
    
    
    func keep_in_touch() {
        let param = [
            "user_id":signUp!.userID,
            "name":txtName.text!,
            "email":txtEmail.text!,
            "message":txtDescription.text!
        ]
        
        showLoader()
        APIFunc.postAPI("keep_in_touch",param) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionaryObject == nil {
                    return
                }
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                    self.navigationController?.popViewController(animated: true)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtEmail.textColor = UIColor.black
        txtName.textColor = UIColor.black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtEmail.text!.isEmpty {
            txtEmail.textColor = UIColor.gray
            txtEmail.text = signUp!.userEmail
        }
        
        if txtName.text!.isEmpty {
            txtName.textColor = UIColor.gray
            txtName.text = signUp!.userName
        }
    }
    
}
