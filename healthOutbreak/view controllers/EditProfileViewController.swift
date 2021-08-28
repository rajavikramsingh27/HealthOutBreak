//
//  EditProfileViewController.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 07/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import SwiftMessageBar
import CountryPickerView


class EditProfileViewController: UIViewController,CountryPickerViewDelegate {
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneNumberTf: UITextField!
    @IBOutlet weak var identityImgView: UIImageView!
    
    @IBOutlet weak var maleView:UIView!
    @IBOutlet weak var femaleView:UIView!
    @IBOutlet weak var ageLbl:UILabel!
    @IBOutlet weak var ageSlider:UISlider!
    
    var strGender = ""
    
    let cpvInternal = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cpvInternal.delegate = self
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
        
    func setData() {
        identityImgView.sd_setImage(with: URL(string:signUp!.userProfile.userProfile), placeholderImage:kDefaultUser)
        nameTf.text = signUp!.userName
        lblCountryCode.text = "\(signUp!.userCountryCode)"
        phoneNumberTf.text = "\(signUp!.userMobile)"
        
        strGender = signUp!.userGender
        if strGender == "Male" {
            let btn = UIButton()
            maleBtn(btn)
        } else {
            let btn = UIButton()
            femaleBtn(btn)
        }
                
        ageLbl.text = "\(signUp!.userAge)"
        let arrUserAge = signUp!.userAge.components(separatedBy: " ")
        if arrUserAge.count > 0 {
            ageSlider.value = Float(Int(arrUserAge[0]) ?? 0)
        }
        
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
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnRemove(_ sender: UIButton) {
        remove_profile()
    }
    
    @IBAction func selectCountryCodeBtn(_ sender: UIButton) {
        cpvInternal.showCountriesList(from: self)
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.lblCountryCode.text = country.phoneCode
    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
       /* if identityImgView.image == UIImage (named:"Group 626.png") {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Select an image", type:.error)
        } else */ if nameTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter name", type:.error)
        } else if phoneNumberTf.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter phone number", type:.error)
        } else if strGender.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter Gender", type:.error)
        } else if ageLbl.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message: "Enter Age", type:.error)
        } else {
            if identityImgView.image == UIImage (named:"Group 626.png") {
                updateProfileWithOutProfileImage()
            } else {
                update_profile()
            }
        }
        
    }
    
    
    
    func updateProfileWithOutProfileImage() {
        let param = ["name":nameTf.text!,
                    "user_country_code":lblCountryCode.text!,
                    "mobile":phoneNumberTf.text!,
                    "user_gender":strGender,
                    "user_age":ageLbl.text!,
                    "user_id":signUp!.userID,
                    "file":""]
        print(param)
            
        showLoader()
        APIFunc.postAPI("update_profile", param) { (json,status, message) in
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
                            if signUp!.saveSignUp(json) {
                                SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    SwiftMessageBar.showMessage(withTitle: "Error", message:message, type:.error)
                                })
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
    
    func update_profile() {
        let param = ["name":nameTf.text!,
                    "user_country_code":lblCountryCode.text!,
                    "mobile":phoneNumberTf.text!,
                    "user_gender":strGender,
                    "user_age":ageLbl.text!,
                    "user_id":signUp!.userID]
        print(param)
            
        showLoader()
        let data = identityImgView.image?.jpegData(compressionQuality: 0.2)
        APIFunc.postAPI_Image("update_profile", data, param,"file") { (json,status, message) in
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
                            if signUp!.saveSignUp(json) {
                                SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    SwiftMessageBar.showMessage(withTitle: "Error", message:message, type:.error)
                                })
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
        
    func remove_profile() {
        let param = ["user_id":signUp!.userID]
        print(param)
        showLoader()
        APIFunc.postAPI("remove_profile", param) { (json,status, message) in
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
                            if signUp!.saveSignUp(json) {
                                self.identityImgView.image = UIImage(named:"Group 626.png")
                                SwiftMessageBar.showMessage(withTitle: "Success", message:message, type:.success)
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                    SwiftMessageBar.showMessage(withTitle: "Error", message:message, type:.error)
                                })
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
    
}



extension EditProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBAction func btnChange(_ selectedButton: UIButton)  {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            identityImgView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
