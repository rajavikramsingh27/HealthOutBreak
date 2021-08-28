//  signupViewController.swift
//  healthOutbreak
//  Created by Ayush Pathak on 02/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.



import UIKit
import SwiftMessageBar
import MLTontiatorView
import FBSDKCoreKit
import FBSDKLoginKit
import SlideMenuControllerSwift

class signupViewController: UIViewController {
    
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        if emailTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter email ID", type:.error)
        } else if !emailTf.text!.isValidEmail() {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter a valid ID", type:.error)
        } else if passwordTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter password", type:.error)
        } else if passwordTf.text!.count < 6 {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Password length must be greater than 6", type:.error)
        } else {
            signup()
        }
    }
    
    func signup() {
        let param = ["email":emailTf.text!,
                     "password":passwordTf.text!,
                     "device_type":"2",
                     "device_token":kTokenFireBase]
        print(param)
        
        showLoader()
        APIFunc.postAPI("signup", param) { (json,status, message) in
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
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "signupAddInformationViewController") as! signupAddInformationViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
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


extension UIViewController {
    func func_facebook() {
        self.view.endEditing(true)
        let deletepermission = GraphRequest(graphPath: "me/permissions/", parameters: [:], httpMethod: HTTPMethod(rawValue: "DELETE"))
        deletepermission.start(completionHandler: {(connection,result,error)-> Void in
            print("the delete permission is \(result ?? "")")
        })
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            DispatchQueue.main.async {
                if (error == nil) {
                    let fbloginresult : LoginManagerLoginResult = result!
                    if (result?.isCancelled)!{
                        return
                    } else if(fbloginresult.grantedPermissions.contains("email")) {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    } else {
                    
                    }
                } else {
                    SwiftMessageBar.showMessage(withTitle: "Error", message:error.debugDescription, type:.error)
                }
            }
        }
    }
    
    func getFBUserData() {
        showLoader()
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: {
                (connection, result, error) -> Void in
                DispatchQueue.main.async {
                    if (error == nil) {
                        let dict = result as! [String:Any]
                        self.dismissLoader()
                        
                        guard let fbid = dict["id"] as? String,
                            let fbmail = dict["email"] as? String,
                            let full_name = dict["name"] as? String else {
                                return
                        }
                        
                        let dict_picture = dict["picture"] as! [String:Any]
                        let data = dict_picture["data"] as! [String:Any]
                        let url_picture = data["url"] as! String
                        
                        arrFBData.removeAll()
                        arrFBData.append(full_name)
                        arrFBData.append(url_picture)
                        
                        let param = ["user_social":fbid,
                                    "device_type":"2",
                                    "device_token":kTokenFireBase]
                        self.func_social_login(param)
                    } else {
                        SwiftMessageBar.showMessage(withTitle: "Error", message:error.debugDescription, type:.error)
                    }
                }
            })
        } else {
            self.dismissLoader()
        }
    }
        
    func func_social_login(_ param:[String:Any]) {
        print(param)
        APIFunc.postAPI("social_login", param) { (json,status, message) in
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
                            self.nextAfterSignUp(json)
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



import GoogleSignIn
extension UIViewController :GIDSignInDelegate {
    func googleSign() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            SwiftMessageBar.showMessage(withTitle: "Error", message:error.localizedDescription, type:.error)
            return
        }
        
        let userId = user.userID
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        arrFBData.removeAll()
        arrFBData.append(fullName!)
        
        let param = ["user_social":userId!,
                    "device_type":"2",
                    "device_token":kTokenFireBase]
        self.func_social_login(param)
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
        SwiftMessageBar.showMessage(withTitle: "Error", message:error.localizedDescription, type:.error)
    }
    
}


import SwiftyJSON
extension UIViewController {
    func nextAfterSignUp(_ json:JSON) {
        if signUp!.userMobile.isEmpty {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signupAddInformationViewController") as! signupAddInformationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            funcLogin(json)
        }
    }
    
     func funcLogin(_ json:JSON) {
        if signUp!.saveSignUp(json) {
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
        }
    }
    
}
