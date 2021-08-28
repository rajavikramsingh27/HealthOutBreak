//  ChangePasswordViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 07/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.



import UIKit
import SwiftMessageBar



class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var txtOldPassword:UITextField!
    @IBOutlet weak var txtNewPassword:UITextField!
    @IBOutlet weak var txtConfirmNewPassword:UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtOldPassword.isSecureTextEntry = true
        txtNewPassword.isSecureTextEntry = true
        txtConfirmNewPassword.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnOldPassword (_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        txtOldPassword.isSecureTextEntry = sender.isSelected
    }
    
    @IBAction func btnNewPassword (_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        txtOldPassword.isSecureTextEntry = !txtOldPassword.isSecureTextEntry
    }
    
    @IBAction func btnConfirmNewPassword (_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        txtConfirmNewPassword.isSecureTextEntry = sender.isSelected
    }
    
    @IBAction func btnChangePassword (_ sender:UIButton) {
        if txtOldPassword.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter old password", type:.error)
        } else if txtOldPassword.text!.count < 6 {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Old password length must be greater than 6", type:.error)
        } else if txtNewPassword.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter new password", type:.error)
        } else if txtNewPassword.text!.count < 6 {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "New password length must be greater than 6", type:.error)
        } else if txtConfirmNewPassword.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter confirm new password", type:.error)
        } else if txtConfirmNewPassword.text!.count < 6 {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Confirm new password length must be greater than 6", type:.error)
        } else {
            change_password()
        }
    }
    
    
    
    func change_password() {
        let param = ["user_id":signUp!.userID,
                     "old_password":txtOldPassword.text!,
                     "new_password":txtNewPassword.text!]
        print(param)
        
        showLoader()
        APIFunc.postAPI("change_password", param) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionaryObject == nil {
                    return
                }
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            signUp = try decoder.decode(SignUp.self, from: jsonData)
                            if signUp!.saveSignUp(json) {
                                SwiftMessageBar.showMessage(withTitle: "Error", message:message, type:.success)
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    SwiftMessageBar.showMessage(withTitle: "Error", message:message, type:.error)
                                })
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
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
