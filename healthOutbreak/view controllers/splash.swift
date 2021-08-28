//
//  splash.swift
//  healthOutbreak
//
//  Created by Ayush Pathak on 01/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseAuth
import SlideMenuControllerSwift



class splash: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
            self.funcGoNextVC()
        }
    }

    
    
    func funcGoNextVC() {
        DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
            
            if let data_1 = UserDefaults.standard.object(forKey: k_user_detals) {
                let json = JSON(data_1)
                print(json)
                
                let decoder = JSONDecoder()
                if let jsonData = json[result_resp].description.data(using: .utf8) {
                    do {
                        signUp = try decoder.decode(SignUp.self, from: jsonData)
                        DispatchQueue.main.async {
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
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "walkthroughViewController") as! walkthroughViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }

}

