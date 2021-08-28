//  AllowPermissionVC.swift
//  healthOutbreak
//  Created by iOS-Appentus on 03/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SlideMenuControllerSwift
import UserNotifications
import CoreLocation


class AllowPermissionVC: UIViewController,PopUpDelegate {
    var isHome = false
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func allowBtn(_ sender:UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"PopUpViewController") as! PopUpViewController
        vc.delegate = self
        
        vc.arrDetails = [UIImage(named:"locationAllow.png")!,"Location","HOM would like to use your location to provide you with accurate updates for the areas you care about."]
        
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func dontAllowPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            if self.isHome {
                self.goTabbar()
            } else {
                self.addPopUp()
            }
        }
    }
    
    func allowPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            if self.isHome {
                let app = UIApplication.shared
                self.askForNotificationPermission(app)
                self.goTabbar()
            } else {
                self.funcCoreLocation()
                self.addPopUp()
            }
        }
    }
    
    func goTabbar() {
        if isHome {
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
    
    func addPopUp() {
        isHome = true
        
        let vc = storyboard?.instantiateViewController(withIdentifier:"PopUpViewController") as! PopUpViewController
        vc.delegate = self
                
        vc.arrDetails = [UIImage(named:"notificationAllow.png"),"Notification","HOM would like to use your location to provide you with accurate updates for the areas you care about."]
        
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)

    }
    
    func askForNotificationPermission(_ application: UIApplication) {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if !isRegisteredForRemoteNotifications {
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in
                    if error == nil {
                        UNUserNotificationCenter.current().delegate = self
                    }
                }
            } else {
                // Fallback on earlier versions
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
        } else {
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self
            } else {
                // Fallback on earlier versions
            }
        }
        application.registerForRemoteNotifications()
    }
    
}

import CoreLocation

extension AllowPermissionVC:CLLocationManagerDelegate {
    func funcCoreLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
        
}

