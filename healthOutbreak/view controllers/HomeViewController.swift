//  HomeViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 04/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import CoreLocation
import GoogleMaps
import SwiftMessageBar
import CoreLocation
import UserNotifications

class HomeViewController: BaseViewController {
    @IBOutlet weak var btnMenu:UIButton!
    @IBOutlet weak var lblLocation:UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var is_location = false
    
    var currentLocationCord = CLLocationCoordinate2D(latitude:0, longitude:0)
    var coOrdinateCurrent = CLLocationCoordinate2D(latitude:0, longitude:0)
    var locationManager = CLLocationManager()
    
    var isLocationSelect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationPermission()
        
        statistics.removeAll()
        newsList.removeAll()
        counts = nil
        
        btnMenu.addTarget(self, action:#selector(onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        addBottomSheetView()
        
        let app = UIApplication.shared
        self.askForNotificationPermission(app)
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"updateLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(currentLocation), name: NSNotification.Name (rawValue:"currentLocation"), object:nil)
    }
    
    @objc func currentLocation () {
        isLocationSelect = false
        
        if currentLocationCord.latitude != 0 || currentLocationCord.longitude != 0 {
            coOrdinateCurrent = currentLocationCord
            setMarkersOnMap()
            home()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        is_location = false
        self.tabBarController?.tabBar.isHidden = false
        let allItems = self.tabBarController?.tabBar.items!
        for i in 0..<allItems!.count{
            allItems![i].title = ""
            if i == 0{
                allItems![i].title = "Home"
            }
        }
        
        if coOrdinateCurrent.latitude != 0 && coOrdinateCurrent.longitude != 0 {
            home()
        }
        
    }
    
    func setMarkersOnMap() {
        self.mapView.clear()
        
        let markerCurrent = GMSMarker()
        
        let markerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 52))
        let image = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 52))
        image.image = #imageLiteral(resourceName: "Group 1818.png")
        markerView.addSubview(image)
        markerView.bringSubviewToFront(image)
        markerCurrent.iconView = markerView
        markerCurrent.position = coOrdinateCurrent
        markerCurrent.map = self.mapView
        markerView.tag = 101
        
        let cameraPosition = GMSCameraPosition.init(latitude:coOrdinateCurrent.latitude, longitude:coOrdinateCurrent.longitude, zoom: 15.0)
        mapView.animate(to: cameraPosition)
        setMarkers()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.isLocationSelect = false
        }
    }
        
    
    
    func setMarkers() {
        for i in 0..<statistics.count {
            let latDouble = Double(statistics[i].lat)!
            let longDouble = Double(statistics[i].lng)!
            
            let cordStatistics = CLLocationCoordinate2D (latitude: latDouble, longitude: longDouble)
            
            let marker = GMSMarker()
            let markerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            markerView.layer.borderColor = UIColor.black.cgColor
            markerView.layer.borderWidth = 1.0
            markerView.layer.masksToBounds = true
            markerView.layer.cornerRadius = 8
            markerView.tag = 111
            
            if statistics[i].caseType.lowercased() == "Potential".lowercased() && statistics[i].status == "1" {
                //                blue
                markerView.backgroundColor = hexStringToUIColor(hex: "#1EC3FF")
            } else if statistics[i].caseType.lowercased() == "Confirmed".lowercased() && statistics[i].status == "1" {
                //                blue
                markerView.backgroundColor = hexStringToUIColor(hex: "#1EC3FF")
            } else if statistics[i].caseType.lowercased() == "Potential".lowercased() {
                //               orange
                markerView.backgroundColor = hexStringToUIColor(hex: "#FF7E29")
            } else if statistics[i].caseType.lowercased() == "Confirmed".lowercased() {
                //                red
                markerView.backgroundColor = hexStringToUIColor(hex: "#FB5151")
            }
            
            marker.iconView = markerView
            marker.position = cordStatistics
            marker.map = self.mapView
        }
    }
    
    @IBAction func btnSearchLocation(_ sender:UIButton) {
        gmsautocomplete()
    }
    
    @objc  func onSlideMenuButtonPressed(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    func addBottomSheetView() {
        let bottomSheetVC = self.storyboard?.instantiateViewController(withIdentifier: "homeBottomSlideableViewController") as! homeBottomSlideableViewController
        
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    
    
    func home() {
        let param = [
            "user_id":signUp!.userID,
            "lat":"\(coOrdinateCurrent.latitude)",
            "lang":"\(coOrdinateCurrent.longitude)"
        ]
        
        showLoader()
        APIFunc.postAPI("home",param) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionaryObject == nil {
                    return
                }
                
                let status = return_status(json.dictionaryObject!)
                switch status {
                case .success:
                    let jsons = json[result_resp]
                    
                    let decoder = JSONDecoder()
                    if let jsonData = jsons["statistics"].description.data(using: .utf8) {
                        do {
                            statistics = try decoder.decode([Statistic].self, from: jsonData)
                            if let jsonData = jsons["news"].description.data(using: .utf8) {
                                newsList = try decoder.decode([NewsList].self, from: jsonData)
                            } else {
                                newsList.removeAll()
                            }
                            
                            if let _ = jsons["counts"].arrayObject {
                                if let jsonData = json["counts"].description.data(using: .utf8) {
                                    counts = try decoder.decode(Counts.self, from: jsonData)
                                }
                            } else {
                                counts = nil
                            }
                            
                            NotificationCenter.default.post(name: NSNotification.Name (rawValue:"home"), object:nil)
                            self.setMarkers()
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



extension HomeViewController:CLLocationManagerDelegate {
    func locationPermission() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationCord = manager.location!.coordinate
        
        if !is_location {
            is_location = true
            coOrdinateCurrent = manager.location!.coordinate
            setMarkersOnMap()
            home()
            coOrdinateCurrent.reverseGeocodeCoordinate { (address) in
                self.lblLocation.text = address
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
        
}



import GooglePlaces
extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    func gmsautocomplete() {
        let gmsautocomplete = GMSAutocompleteViewController()
        gmsautocomplete.delegate = self
        present(gmsautocomplete, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let localized = "Address not found"
        isLocationSelect = true
        
        lblLocation.text = place.formattedAddress ?? localized
        coOrdinateCurrent = place.coordinate
        
        setMarkersOnMap()
        home()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
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



extension HomeViewController:GMSMapViewDelegate {
      func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if !isLocationSelect {
            addMarker(position.target)
        }
    }
    
    func addMarker(_ coOrdinateCurrent:CLLocationCoordinate2D) {
        self.coOrdinateCurrent = coOrdinateCurrent
        
        self.mapView.clear()
        
        let markerCurrent = GMSMarker()
        let markerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 52))
        let image = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 35, height: 52))
        image.image = #imageLiteral(resourceName: "Group 1818.png")
        markerView.addSubview(image)
        markerView.bringSubviewToFront(image)
        markerCurrent.iconView = markerView
        markerCurrent.position = coOrdinateCurrent
        markerCurrent.map = self.mapView
        markerView.tag = 101
        
        self.coOrdinateCurrent.reverseGeocodeCoordinate { (address) in
            self.lblLocation.text = address
        }
        setMarkers()
    }
    
}
