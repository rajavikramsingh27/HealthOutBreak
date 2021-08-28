//  RistFactorsViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 07/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar

class RistFactorsViewController: UIViewController {
    @IBOutlet weak var collChhoseYourInterest:UICollectionView!
    
//    var arrRistFactors = ["Heart Diseases","Respiratory Problems","Allergies"]
    var arrRistFactorSelected = [Bool]()
        
    var risk_fector_jsonSelected = [String:String]()
//    var getRisk_fector_json = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        riskFector.removeAll()
        get_risk_fector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setData() {
        for i in 0..<riskFector.count {
//            for j in 0..<signUp!.riskFector.dictionary.count {
                for (key,value) in signUp!.riskFector.dictionary {
                    if riskFector[i].name.lowercased() == "\(value)".lowercased() {
                        arrRistFactorSelected[i] = true
                    }
                }
//            }
        }
        collChhoseYourInterest.reloadData()
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnSubmit(_ sender:UIButton) {
//        if !arrRistFactorSelected.contains(true) {
//            SwiftMessageBar.showMessage(withTitle: "Error", message: "Select risk factors", type:.error)
//            return
//        }
        update_risk()
    }
    
    
    func get_risk_fector() {
        showLoader()
        
        APIFunc.getAPI("get_risk_fector", [:]) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionary == nil {
                    return
                }
                
//                self.getRisk_fector_json = json.dictionaryObject![result_resp] as? [[String:String]] ?? [[:]]
//                print(self.getRisk_fector_json)
                
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            riskFector = try decoder.decode([RiskFector].self, from: jsonData)
                            for _ in riskFector {
                                self.arrRistFactorSelected.append(false)
                            }
                            self.collChhoseYourInterest.reloadData()
                            
                            if !(signUp!.interest?.isEmpty ?? false) {
                                self.setData()
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
    
    func update_risk() {
        
        for i in 0..<arrRistFactorSelected.count {
            if arrRistFactorSelected[i] {
                risk_fector_jsonSelected["\(i+1)"] = riskFector[i].name
            }
        }
        
        var strRiskFector = ""
        
        if arrRistFactorSelected.count == 0 {
            strRiskFector = ""
        } else {
            strRiskFector = risk_fector_jsonSelected.json
        }
        
        print(risk_fector_jsonSelected)
        let param = ["user_id":signUp!.userID,"risk_fector_json":strRiskFector]
        APIFunc.postAPI("update_risk",param) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionary == nil {
                    return
                }
                
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    if signUp!.saveSignUp(json) {
                        SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                        self.navigationController?.popViewController(animated: true)
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



extension RistFactorsViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = riskFector[indexPath.row].name.sizeText(UIFont(name:"Rockwell", size:16.0)!)
//        let widht = size.width+CGFloat(70)
//        return CGSize (width:widht, height:45)
        
        let widthFinal = collectionView.frame.width/2 - 15
        return CGSize(width: widthFinal, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return riskFector.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! SignUpAddInfoCollectionCell
        
        let riskFac = riskFector[indexPath.row]
        cell.infoLbl.text = riskFac.name
        cell.containerView.backgroundColor = arrRistFactorSelected[indexPath.row] ? hexStringToUIColor(hex:"#4C2AB1") : hexStringToUIColor(hex:"#C1C1C1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<arrRistFactorSelected.count {
            if i == indexPath.row {
                arrRistFactorSelected[i] = !arrRistFactorSelected[i]
            }
        }
        collChhoseYourInterest.reloadData()
    }
    
}

