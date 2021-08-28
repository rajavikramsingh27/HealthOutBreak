//  AddCaseViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import GoogleMaps
import SwiftMessageBar


class AddCaseViewController: UIViewController {
    @IBOutlet weak var mapView:GMSMapView!

    @IBOutlet var optionsViews:[UIButton]!
    @IBOutlet var optionsButtons:[UIButton]!

    @IBOutlet weak var collAddCase:UICollectionView!

    //    var arrAddCase = ["Covid","Ebola","Swine Flu","Flu"]
    var arrAddCaseSelected = [Bool]()

    var coOrdinateCurrent = CLLocationCoordinate2DMake(0.0, 0.0)
    var locationManager = CLLocationManager()
    var isLocation = false

    var strCaseType = ""
    var strCaseOption = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDisease.removeAll()
        get_disease()
        
        mapView.delegate = self
        locationPermission()
                
        for i in 0..<optionsButtons.count {
            optionsButtons[i].tag = i
            optionsButtons[i].addTarget(self, action:#selector(optionsButtons(_:)), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnAdd(_ sender:UIButton) {
        if !arrAddCaseSelected.contains(true) {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Select an case option", type:.error)
        } else if strCaseType.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Select a case type", type:.error)
        } else {
            alert()
            add_case()
        }
    }
    
    @IBAction func optionsButtons(_ sender:UIButton) {
        for i in 0..<optionsButtons.count {
            if i == sender.tag {
                optionsViews[i].layer.borderColor = hexStringToUIColor(hex: "#4C2AB1").cgColor
                if i == 0 {
                    strCaseType = "Potential"
                } else {
                    strCaseType = "Confirmed"
                }
            } else {
                optionsViews[i].layer.borderColor = hexStringToUIColor(hex: "#C1C1C1").cgColor
            }
        }
    }
    
    func get_disease() {
        showLoader()
        APIFunc.getAPI("get_disease", [:]) { (json,status, message) in
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
                            getDisease = try decoder.decode([GetDisease].self, from: jsonData)
                            
                            for _ in getDisease {
                                self.arrAddCaseSelected.append(false)
                            }
                            self.collAddCase.reloadData()
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
    
    
    
    func add_case() {
        showLoader()
        
        let param = ["user_id":signUp!.userID,
                     "case_type":strCaseType,
                     "case_disease":strCaseOption,
                     "lat":"\(coOrdinateCurrent.latitude)",
                     "lng":"\(coOrdinateCurrent.longitude)"]
        print(param)
        
        APIFunc.postAPI("add_case",param) { (json,status, message) in
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
    
    
    
    func alert() {
        let param = ["uId":signUp!.userID,
                     "status":"T",
                     "alertType":"mobile",
                     "coordinates": [
                        coOrdinateCurrent.latitude,
                        coOrdinateCurrent.longitude
                    ]
                ] as [String : Any]
        print(param)
        
        let headers = [
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlN2M2YTNhODM4NWExNWM3ODFhMjIyMSIsImlhdCI6MTU4NTgxNjcyNH0.htNZQOpmOeHiv7iYyBDM6RN5yRLFg9ZXW7MDBebU1cU",
          "Content-Type": "application/json",
          "cache-control": "no-cache",
          "Postman-Token": "7c4bd32e-3adf-4a00-9875-3fd11642259f"
        ]
        
        ModelAddSymptoms.postAPI("alert", headers,param) { (response) in
            print(response)
        }
        
    }
    
    
}



extension AddCaseViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = getDisease[indexPath.row].name.sizeText(UIFont(name:"Rockwell", size:16.0)!)
        let widht = size.width+CGFloat(70)
        return CGSize (width:widht, height:45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getDisease.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! SignUpAddInfoCollectionCell
        
        cell.infoLbl.text = getDisease[indexPath.row].name
        cell.containerView.backgroundColor = arrAddCaseSelected[indexPath.row] ? hexStringToUIColor(hex:"#4C2AB1") : hexStringToUIColor(hex:"#C1C1C1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        strCaseOption = getDisease[indexPath.row].name
        
        for i in 0..<arrAddCaseSelected.count {
            if i == indexPath.row {
                arrAddCaseSelected[i] = true
            } else {
                arrAddCaseSelected[i] = false
            }
        }
        collAddCase.reloadData()
    }
    
}



extension AddCaseViewController:GMSMapViewDelegate {
    func cameraPosition(_ cordinate:CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude:cordinate.latitude, longitude:cordinate.longitude, zoom: 15)
        mapView.camera = camera
        mapView?.animate(to: camera)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        addMarker(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return true
    }
    
    func addMarker(_ coOrdinateCurrent:CLLocationCoordinate2D) {
        self.coOrdinateCurrent = coOrdinateCurrent
        
        mapView.clear()
        let marker = GMSMarker(position:coOrdinateCurrent)
        
        marker.map =  self.mapView
        
        let viewMarker = UIView (frame:  CGRect (x: 0, y: 0, width: 40, height:55))
        let imgMarker = UIImageView.init(image: UIImage (named: "pin.png"))
        imgMarker.frame = viewMarker.frame
        viewMarker.addSubview(imgMarker)
        marker.iconView = viewMarker
    }
    
    
}



import CoreLocation
extension AddCaseViewController:CLLocationManagerDelegate {
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
        if !isLocation {
            isLocation = true
            coOrdinateCurrent = manager.location!.coordinate
            cameraPosition(coOrdinateCurrent)
            
            addMarker(coOrdinateCurrent)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

