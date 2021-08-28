//  SymptomaticViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit


class SymptomaticViewController: UIViewController {
    @IBOutlet weak var tblAsymptomatic:UITableView!
    @IBOutlet weak var HeightTblAsymptomatic:NSLayoutConstraint!
    
    @IBOutlet weak var tblNearByFacility:UITableView!
    @IBOutlet weak var heightNearByFacility:NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDescriptio:UILabel!
    
    var coOrdinateCurrent = CLLocationCoordinate2DMake(0.0, 0.0)
    var locationManager = CLLocationManager()
    var isLocation = false
    
//    let arrAsymptomaticTitle = ["Attempt to quarantine yourself","Monitor your symptoms","Drink plenty of liquids","Rest and Sleep when possible"]
//    let arrAsymptomaticIcon = ["Group 1884.png","Group 1885.png","Group 1886.png","Group 1887.png"]
            
    var arrHospitals = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblAsymptomatic.isHidden = false
        locationPermission()
        setData()
    }
    
    func setData() {
        HeightTblAsymptomatic.constant = CGFloat(80*preventive.count)
        
        lblTitle.text = descriptionSymtom.title
        lblDescriptio.text = descriptionSymtom.descriptionDescription
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnSymptotatic(_ sender:UIButton) {
        let addSymptoms = storyboard?.instantiateViewController(withIdentifier:"AddSymptomsViewController") as! AddSymptomsViewController
        navigationController?.pushViewController(addSymptoms, animated:true)
    }
}



extension SymptomaticViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView==tblAsymptomatic {
            return 80
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAsymptomatic {
            return preventive.count
        } else {
            return self.arrHospitals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==tblAsymptomatic {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for:indexPath) as! HomeTableViewCell
            
            let prevData = preventive[indexPath.row]
            cell.descLbl.text = prevData.name
            cell.iconImg.sd_setImage(with: URL(string:prevData.icon.userProfile), placeholderImage: UIImage(named:""))
                        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell-1", for:indexPath) as! HelpTableViewCell
            
            let helpData = self.arrHospitals[indexPath.row]
            cell.lblName.text = "\(helpData["name"] ?? "Google Name")"
            cell.lblLocation.text = "\(helpData["vicinity"] ?? "Google Address" )"
            cell.lblNumber.text = "\(helpData["formatted_phone_number"] ?? "")"
            
            cell.btnCall.isHidden = "\(helpData["formatted_phone_number"] ?? "")".isEmpty ? true :false
            
            cell.btnCall.tag = indexPath.row
            cell.btnCall.addTarget(self, action:#selector(selectButton(_:)), for:.touchUpInside)
                    
            return cell
        }
    }
    
    @IBAction func selectButton(_ sender:UIButton) {
        let helpData = self.arrHospitals[sender.tag]
        let number = "\(helpData["formatted_phone_number"] ?? "Google Number")".replacingOccurrences(of: " ", with: "")
        
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}



import CoreLocation
extension SymptomaticViewController:CLLocationManagerDelegate {
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
            
            showLoader()
            ModelAddSymptoms.getNeartestHospital(coOrdinateCurrent) { (response) in
                DispatchQueue.main.async {
                    self.dismissLoader()
                    
                    self.arrHospitals = response["results"] as! [[String:Any]]
                    print(self.arrHospitals)
                    
                    for i in 0..<self.arrHospitals.count {
                        self.getNumberFromPlaceID(i, "\(self.arrHospitals[i]["place_id"] ?? "")")
                    }
                }
            }
        }
    }
    
    func getNumberFromPlaceID(_ i:Int,_ placeID:String) {
        showLoader()
        ModelAddSymptoms.getNumberFromPlaceID(placeID) { (response) in
            DispatchQueue.main.async {
                self.dismissLoader()
                if let dictHospitals = response["result"] as? [String:Any] {
                    if let formatted_phone_number = dictHospitals["formatted_phone_number"] as? String {
                        self.arrHospitals[i]["formatted_phone_number"] = formatted_phone_number
                    } else {
                        self.arrHospitals[i]["formatted_phone_number"] = ""
                    }
                } else {
                    self.arrHospitals[i]["formatted_phone_number"] = ""
                }
                
                self.heightNearByFacility.constant = CGFloat(122*self.arrHospitals.count)
                self.tblNearByFacility.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

