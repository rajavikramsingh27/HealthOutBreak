//  loginViewController.swift
//  healthOutbreak
//  Created by Ayush Pathak on 01/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SlideMenuControllerSwift
import SwiftMessageBar


class loginViewController: UIViewController {
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var showPassBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTf.isSecureTextEntry = !showPassBtn.isSelected
    }
    
    @IBAction func showPassBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTf.isSecureTextEntry = !showPassBtn.isSelected
    }
    
    @IBAction func fbLoginBtn(_ sender: UIButton) {
        isFacebook = true
        func_facebook()
    }
    
    @IBAction func googleLoginBtn(_ sender: Any) {
        isFacebook = false
        googleSign()
    }
    
    @IBAction func forgotPassBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if emailTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter email ID", type:.error)
        } else if !emailTf.text!.isValidEmail() {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter a valid ID", type:.error)
        } else if passwordTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter password", type:.error)
        } else if passwordTf.text!.count < 6 {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Password length must be greater than 6", type:.error)
        } else {
            login()
        }
        
    }

    func login() {
        let param = ["email":emailTf.text!,
                     "password":passwordTf.text!,
                     "device_type":"2",
                     "device_token":kTokenFireBase]
        print(param)
        
        showLoader()
        APIFunc.postAPI("login", param) { (json,status, message) in
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
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let customTabbarViewController = (storyboard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController)!
                                    let leftMenuViewController = (storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController)!
                                    
                                    let navigationViewController: UINavigationController = UINavigationController(rootViewController: customTabbarViewController)
                                    
                                    //Create Side Menu View Controller with main, left and right view controller
                                    let sideMenuViewController = SlideMenuController(mainViewController: navigationViewController, leftMenuViewController: leftMenuViewController)
                                    let appedl = UIApplication.shared.delegate as! AppDelegate
                                    appedl.window?.rootViewController = sideMenuViewController
                                    sideMenuViewController.changeLeftViewWidth(UIScreen.main.bounds.width)
                                    navigationViewController.navigationBar.isHidden = true
                                    
                                    appedl.window?.makeKeyAndVisible()
                                })
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    SwiftMessageBar.showMessage(withTitle: "Error", message:"\(json["message"])", type:.error)
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
    
    @IBAction func signupBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signupViewController") as! signupViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
