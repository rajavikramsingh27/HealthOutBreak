//  AddPlansViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar
import DatePickerDialog


class AddPlansViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var collAddTravelInfo:UICollectionView!
        
    @IBOutlet weak var fromWhereTxt:UITextField!
    @IBOutlet weak var toWhereTxt:UITextField!
    @IBOutlet weak var startDateTxt:UITextField!
    @IBOutlet weak var endDateTxt:UITextField!
    @IBOutlet weak var placeOfStayTxt:UITextField!
    @IBOutlet weak var switchNotify:UISwitch!
    
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var btnAdd:UIButton!
    
    
    var arrRistFactors = ["Tourist","Business","Family and Friends"]
    var arrRistFactorSelected = [Bool]()
    var strPurposeVisit = ""
    var strReceiveTravelNotification = "0"
    
    var strHeader = ""
    var selectedTravelData:GetTravel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeader.text = strHeader
        
        for _ in arrRistFactors {
            arrRistFactorSelected.append(false)
        }
        
        if strHeader != "Add Plans" {
            setData()
        }
    }
    
    func setData() {
        fromWhereTxt.text = selectedTravelData.fromWhere
        toWhereTxt.text = selectedTravelData.toWhere
        startDateTxt.text = selectedTravelData.startDate
        endDateTxt.text = selectedTravelData.endDate
        placeOfStayTxt.text = selectedTravelData.placeStay
        strReceiveTravelNotification = selectedTravelData.isNotify
        switchNotify.isOn = strReceiveTravelNotification == "1" ? true : false
        
        strPurposeVisit = selectedTravelData.perpose
        for i in 0..<arrRistFactors.count {
            if arrRistFactors[i] == strPurposeVisit {
                arrRistFactorSelected[i] = true
            }
        }
        collAddTravelInfo.reloadData()
        
        btnAdd.setTitle("Update", for: .normal)
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func endDate(_ sender: UIButton) {
        let minimumDate = Calendar.current.date(byAdding:.year, value:0, to: Date())
        let maximumDate = Calendar.current.date(byAdding:.year, value:17, to: Date())
        
        DatePickerDialog().show("End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: minimumDate, maximumDate:maximumDate,datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.endDateTxt.text = formatter.string(from: dt)
            }
        }
        
    }
    
    @IBAction func startDateBtn(_ sender: UIButton) {
        let minimumDate = Calendar.current.date(byAdding:.year, value:0, to: Date())
        let maximumDate = Calendar.current.date(byAdding:.year, value:17, to: Date())
        
        DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: minimumDate, maximumDate:maximumDate,datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                self.startDateTxt.text = formatter.string(from: dt)
            }
        }
    }
    
    @IBAction func recieveTravelNotification(_ sender:UISwitch) {
        strReceiveTravelNotification = sender.isOn ? "1" : "0"
    }
    
    @IBAction func btnAdd(_ sender:UIButton) {
        if !validation() {
            return
        } else {
            if strHeader == "Add Plans" {
                add_travel_info()
            } else {
                update_travel_info()
            }
        }
    }
    
    func add_travel_info() {
        let param = ["from_where":fromWhereTxt.text!,
                     "user_id":signUp!.userID,
                     "to_where":toWhereTxt.text!,
                     "start_date":startDateTxt.text!,
                     "end_date":endDateTxt.text!,
                     "place_stay":placeOfStayTxt.text!,
                     "perpose":strPurposeVisit,
                     "is_notify":strReceiveTravelNotification]
        print(param)
        
        showLoader()
        APIFunc.postAPI("add_travel_info", param) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionaryObject == nil {
                    return
                }
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                    self.navigationController?.popViewController(animated:true)
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
    
    
    
    func update_travel_info() {
        let param = ["from_where":fromWhereTxt.text!,
                     "user_id":signUp!.userID,
                     "to_where":toWhereTxt.text!,
                     "start_date":startDateTxt.text!,
                     "end_date":endDateTxt.text!,
                     "place_stay":placeOfStayTxt.text!,
                     "perpose":strPurposeVisit,
                     "is_notify":strReceiveTravelNotification,
                     "travel_info_id":selectedTravelData.id]
        print(param)
        
        showLoader()
        APIFunc.postAPI("update_travel_info", param) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionaryObject == nil {
                    return
                }
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                    self.navigationController?.popViewController(animated:true)
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
    
    func validation() -> Bool {
        var isValid = false
        if fromWhereTxt.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter from where", type:.error)
            isValid = false
        } else if toWhereTxt.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter to where", type:.error)
            isValid = false
        } else if startDateTxt.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter start date", type:.error)
            isValid = false
        } else if endDateTxt.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter end date", type:.error)
            isValid = false
        } else if strPurposeVisit.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Select purpose of visit", type:.error)
            isValid = false
        } else {
            isValid = true
        }
        
        return isValid
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == startDateTxt || textField == endDateTxt {
            return false
        }
        
        return true
    }
    
}


extension AddPlansViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = arrRistFactors[indexPath.row].sizeText(UIFont(name:"Rockwell", size:16.0)!)
        let widht = size.width+CGFloat(70)
        return CGSize (width:widht, height:45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRistFactors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! SignUpAddInfoCollectionCell
        
        cell.infoLbl.text = arrRistFactors[indexPath.row]
        cell.containerView.backgroundColor = arrRistFactorSelected[indexPath.row] ? hexStringToUIColor(hex:"#4C2AB1") : hexStringToUIColor(hex:"#C1C1C1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        strPurposeVisit = arrRistFactors[indexPath.row]
        for i in 0..<arrRistFactorSelected.count {
            if i == indexPath.row {
                arrRistFactorSelected[i] = true
            } else {
                arrRistFactorSelected[i] = false
            }
        }
        collAddTravelInfo.reloadData()
    }
    
}



