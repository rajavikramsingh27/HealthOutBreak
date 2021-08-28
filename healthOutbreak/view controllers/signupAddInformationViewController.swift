//  signupAddInformationViewController.swift
//  healthOutbreak
//  Created by Ayush Pathak on 02/04/20.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import CountryPickerView
import SwiftMessageBar
import FirebaseAuth
import SDWebImage
import SwiftyJSON

var phoneNoCountryCode = ""
var arrFBData = [String]()
var signUpJSON = JSON()

class signupAddInformationViewController: UIViewController {
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneNumberTf: UITextField!
    @IBOutlet weak var viewImgContainer: UIView!
    @IBOutlet weak var identityImgView: UIImageView!
    @IBOutlet weak var backImgViewMain: RoundButton!
    
    @IBOutlet weak var maleView:UIView!
    @IBOutlet weak var femaleView:UIView!
    @IBOutlet weak var ageLbl:UILabel!
    
    @IBOutlet weak var collAddInfo:UICollectionView!
    
//    var arrRistFactors = ["Heart Disease","Respiratory Problems","Allergies"]
    var arrRistFactorSelected = [Bool]()
    let cpvInternal = CountryPickerView()
    
    var strGender = ""
    var risk_fector_jsonSelected = [String:String]()
    var getRisk_fector_json = [[String:String]]()
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        riskFector.removeAll()
        get_risk_fector()
        
        cpvInternal.delegate = self
        viewImgContainer.alpha = 0.0
        viewImgContainer.clipsToBounds = true
        viewImgContainer.layer.cornerRadius = 16.0
        maleView.backgroundColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        femaleView.backgroundColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        if arrFBData.count > 0 {
            nameTf.text = arrFBData[0]
            
//            if arrFBData.count > 1 {
//                self.viewImgContainer.alpha = 1.0
//                identityImgView.sd_setImage(with: URL(string:arrFBData[1]), placeholderImage: UIImage(named:""))
//                self.backImgViewMain.borderWidth = 0.0
//            }
        }        
        
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        if nameTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter full name", type:.error)
        } else if phoneNumberTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter phone number", type:.error)
        } /*else if identityImgView.image == nil {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Select an image", type:.error)
        } */else if strGender.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter Gender", type:.error)
        } else if ageLbl.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter Age", type:.error)
        }/* else if !arrRistFactorSelected.contains(true) {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Select risk factors", type:.error)
        } */else {
            add_user_info()
        }
        
    }
    
    @IBAction func uploadIdImageBtn(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { image in
            self.viewImgContainer.alpha = 1.0
            self.identityImgView.image = image
            self.backImgViewMain.borderWidth = 0.0
        }
    }
    
    @IBAction func selectCountryCodeBtn(_ sender: UIButton) {
        cpvInternal.showCountriesList(from: self)
    }
    
    @IBAction func maleBtn(_ sender: UIButton) {
        maleView.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.1647058824, blue: 0.6941176471, alpha: 1)
        femaleView.backgroundColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        
        strGender = "Male"
    }
    
    @IBAction func femaleBtn(_ sender: UIButton) {
        maleView.backgroundColor = #colorLiteral(red: 0.7568627451, green: 0.7568627451, blue: 0.7568627451, alpha: 1)
        femaleView.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.1647058824, blue: 0.6941176471, alpha: 1)
        
        strGender = "Female"
    }
    
    @IBAction func slider(_ sender:UISlider) {
        ageLbl.text = "\(Int64(sender.value)) Years"
    }
    
    func get_risk_fector() {
        showLoader()
        
        APIFunc.getAPI("get_risk_fector", [:]) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionary == nil {
                    return
                }
                
                self.getRisk_fector_json = json.dictionaryObject![result_resp] as? [[String:String]] ?? [[:]]
                print(self.getRisk_fector_json)
                
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            signUpJSON = json
                            riskFector = try decoder.decode([RiskFector].self, from: jsonData)
                            for _ in riskFector {
                                self.arrRistFactorSelected.append(false)
                            }
                            self.collAddInfo.reloadData()
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
    
    func add_user_info() {
        for i in 0..<arrRistFactorSelected.count {
            if arrRistFactorSelected[i] {
                risk_fector_jsonSelected["\(i+1)"] = riskFector[i].name
            }
        }
        
        print(risk_fector_jsonSelected)
        
        let param = ["user_name":nameTf.text!,
                    "country_code":lblCountryCode.text!,
                    "mobile_number":phoneNumberTf.text!,
                    "gender":strGender,
                    "age":ageLbl.text!,
                    "risk_fector_json":risk_fector_jsonSelected.json,
                    "user_id":signUp!.userID]
        print(param)
        
        showLoader()
        let data = identityImgView.image?.jpegData(compressionQuality: 0.2)
        APIFunc.postAPI_Image("add_user_info", data, param,"file") { (json,status, message) in
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
                            phoneNoCountryCode = self.lblCountryCode.text!+self.phoneNumberTf.text!
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPhoneNumberVC") as! VerifyPhoneNumberVC
                            self.navigationController?.pushViewController(vc, animated: true)
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



extension signupAddInformationViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = riskFector[indexPath.row].name.sizeText(UIFont(name:"Rockwell", size:16.0)!)
        let widht = size.width+CGFloat(70)
        return CGSize (width:widht, height:45)
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
        collAddInfo.reloadData()
    }
    
}

extension signupAddInformationViewController:CountryPickerViewDelegate{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.lblCountryCode.text = country.phoneCode
    }
}
