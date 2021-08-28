//  AppDelegate.swift
//  healthOutbreak
//  Created by Ayush Pathak on 01/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import GooglePlacesAPI
import SwiftMessageBar
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation


//18602677777
//022422077777


let googleSignInKey = "941629656802-99bgosrf94985kk273f0f8dc9lj8jsf2.apps.googleusercontent.com"
let apiGoogleKey = "AIzaSyCBJCuv-FVLIBebHZg6VjlW32UrM7Ghuec"


var kTokenFireBase = ""

var isFacebook = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var coOrdinateCurrent = CLLocationCoordinate2D(latitude:0, longitude:0)
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
                
        GIDSignIn.sharedInstance().clientID = googleSignInKey //"YOUR_CLIENT_ID"
        
        GMSServices.provideAPIKey(apiGoogleKey)
        
        GMSPlacesClient.provideAPIKey(apiGoogleKey)
        GooglePlaces.provide(apiKey: apiGoogleKey)
        
        let config = SwiftMessageBar.Config.Builder()
        .withErrorColor(hexStringToUIColor(hex:"#cc0000"))
        .withSuccessColor(hexStringToUIColor(hex:"#00AB66"))
        .withTitleFont(UIFont (name:"NunitoSans-Bold", size:24.0)!)
        .withMessageFont(UIFont (name:"NunitoSans-Bold", size: 16.0)!)
        .build()
        
        SwiftMessageBar.setSharedConfig(config)
        
        func_firebase()
        
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(update_location), name: NSNotification.Name (rawValue:"updateLocation"), object:nil)
        
        locationPermission()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        update_location()
    }
    
}


import Firebase
import FirebaseMessaging


extension AppDelegate : MessagingDelegate {
    func func_firebase()  {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        kTokenFireBase = fcmToken
    }
    
}



import UserNotifications
extension UIViewController:UNUserNotificationCenterDelegate {
    func openNotificationInSettings() {
        let alertController = UIAlertController(title: "Notification Alert", message: "Please enable Notification from Settings to never miss a text.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
//            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .badge, .sound])
        
//        let userInfo = notification.request.content.userInfo
//        let dictUserInfo = userInfo as! [String:Any]
//
//        let dictResult = "\(dictUserInfo["gcm.notification.result"]!)".dictionary
//        print(dictResult)
//
//        if extractUserInfo(userInfo).title.lowercased() == "New message".lowercased() {
//            NotificationCenter.default.post(name: NSNotification.Name (rawValue:"newMessage"), object:nil)
//        } else if extractUserInfo(userInfo).title.lowercased() == "Meeting invitation".lowercased() {
//            NotificationCenter.default.post(name: NSNotification.Name (rawValue:"sendInvitaion"), object:nil)
//        }
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        let userInfo = response.notification.request.content.userInfo
        
        switch UIApplication.shared.applicationState {
        case .active:
            funcTapNotification(userInfo)
            break
//        case .inactive:
//            dictNotifRecieveInactive = userInfo
//            if isOnApp {
//                funcTapNotification(userInfo)
//            }
            break
        case .background:
            funcTapNotification(userInfo)
            break
        default:
            break
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    @objc func notifRecieveInactive(_ noti:Notification) {
//        if extractUserInfo(noti.userInfo!).title.lowercased() == "New message".lowercased() {
//            let dictResult = "\(noti.userInfo!["gcm.notification.result"]!)".dictionary
//
//            let storyboard = UIStoryboard (name: "Main_2", bundle: nil)
//            let chat_VC = storyboard.instantiateViewController(withIdentifier:"Chat_ViewController") as! Chat_ViewController
//
//            chat_VC.user = User (userID:"\(dictResult["user_id"]!)", userProfile:"", userName:"\(dictResult["user_name"]!)", userEmail: "", userPassword: "", userCountryCode: "", userMobile: "", userDob: "", userLoginType: "", userSocial: "", userDeviceType: "", userDeviceToken: "", userLat: "", userLang: "", userStatus: "", created: "")
//
//            dictNotifRecieveInactive.removeAll()
//
//            let rootViewController = self.window!.rootViewController as! UINavigationController
//            rootViewController.pushViewController(chat_VC, animated: true)
//        } else if extractUserInfo(noti.userInfo!).title.lowercased() == "Meeting invitation".lowercased() {
//            NotificationCenter.default.post(name: NSNotification.Name (rawValue:"notiInactiveEvent"), object:nil)
//        }
    }
    
    func funcTapNotification(_ userInfo:[AnyHashable:Any]) {
//        let dictResult = "\(userInfo["gcm.notification.result"]!)".dictionary
//
//        if extractUserInfo(userInfo).title.lowercased() == "New message".lowercased() {
//            let storyboard = UIStoryboard (name: "Main_2", bundle: nil)
//            let chat_VC = storyboard.instantiateViewController(withIdentifier:"Chat_ViewController") as! Chat_ViewController
//
//            chat_VC.user = User (userID:"\(dictResult["user_id"]!)", userProfile:"", userName:"\(dictResult["user_name"]!)", userEmail: "", userPassword: "", userCountryCode: "", userMobile: "", userDob: "", userLoginType: "", userSocial: "", userDeviceType: "", userDeviceToken: "", userLat: "", userLang: "", userStatus: "", created: "")
//
//            dictNotifRecieveInactive.removeAll()
//
//            let rootViewController = self.window!.rootViewController as! UINavigationController
//            rootViewController.pushViewController(chat_VC, animated: true)
//        } else if extractUserInfo(userInfo).title.lowercased() == "Meeting invitation".lowercased() {
//            NotificationCenter.default.post(name: NSNotification.Name (rawValue:"notiInactiveEvent"), object:nil)
//        }
    }
    
}



// Swift
// AppDelegate.swift

extension AppDelegate {
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if isFacebook {
            return ApplicationDelegate.shared.application(app, open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        } else {
            return (GIDSignIn.sharedInstance()?.handle(url))!
        }
        
    }
    
}



extension AppDelegate:CLLocationManagerDelegate {
    func locationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coOrdinateCurrent = manager.location!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
        
    @objc func update_location() {
        if signUp?.userID == nil {
            return
        } else if coOrdinateCurrent.latitude == 0 {
            return
        }  else if coOrdinateCurrent.longitude == 0 {
            return
        }
        
        let param = [
            "user_id":signUp!.userID,
            "lat":"\(coOrdinateCurrent.latitude)",
            "lng":"\(coOrdinateCurrent.longitude)"
        ]
//        print(param)
        
        APIFunc.postAPI("update_location",param) { (json,status, message) in
            DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                self.update_location()
            }
        }
        
    }
    
}

