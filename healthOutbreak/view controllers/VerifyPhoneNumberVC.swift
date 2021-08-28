//  VerifyPhoneNumberVC.swift
//  healthOutbreak
//  Created by iOS-Appentus on 03/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import FirebaseAuth
import SwiftMessageBar


class VerifyPhoneNumberVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var otpTxt:[UITextField]!
    @IBOutlet weak var lblPhoneNumber:UILabel!
    
    @IBOutlet weak var didntRecieveOTP:UILabel!
    @IBOutlet weak var resendOTP:UIButton!
    
    var verificationID = ""
    var verificationCode = ""
    
    var timer = Timer()
    var timeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPhoneNumber.text = phoneNoCountryCode
        
        for i in 0..<otpTxt.count {
            otpTxt[i].keyboardType = .numberPad
            otpTxt[i].delegate = self
            otpTxt[i].tag = i
            otpTxt[i].addTarget(self, action:#selector(textField(_:)), for:.editingChanged)
        }
        
        funcVerification()
        otpFunctionality()
    }
              
    func otpFunctionality() {
        didntRecieveOTP.isHidden = true
        resendOTP.isHidden = true
        
        timer = Timer (timeInterval:1.0, target:self, selector:#selector(otpShow), userInfo:nil, repeats: true)
    }
    
    @objc func otpShow() {
        timeCount += 1
        
        if timeCount > 30 {
            timeCount = 0
            timer.invalidate()
            didntRecieveOTP.isHidden = false
            resendOTP.isHidden = false
        }
    }
    
    func funcVerification() {
        showLoader()
        
        print(phoneNoCountryCode)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNoCountryCode, uiDelegate: nil) { (verificationID, error) in
            DispatchQueue.main.async {
                self.dismissLoader()
                error?.localizedDescription
                if error == nil {
                    self.verificationID = verificationID!
                } else {
                    SwiftMessageBar.showMessage(withTitle: "Error", message:error.debugDescription, type:.error)
                }
            }
        }
        
    }
    
    @IBAction func btnChange(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendNewCode(_ sender:UIButton) {
        otpFunctionality()
        funcVerification()
    }
    
    @IBAction func btnVerify(_ sender:UIButton) {
        var isValid = false
        for i in 0..<otpTxt.count {
            if otpTxt[i].text!.isEmpty {
                SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter a valid OTP", type:.error)
                isValid = false
                break
            } else {
                isValid = true
            }
        }
        
        if !isValid {
            return
        }
        
        for i in 0..<otpTxt.count {
            verificationCode = verificationCode+otpTxt[i].text!
        }
        
        showLoader()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            DispatchQueue.main.async {
                self.dismissLoader()
                if error == nil {
                    signUp!.saveSignUp(signUpJSON)
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTravelInfoVC") as! AddTravelInfoVC
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseYourInteresetVC") as! ChooseYourInteresetVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    @IBAction func textField(_ sender:UITextField) {
        if sender.text!.count > 0 {
            if sender.tag == otpTxt.count-1 {
                self.view.endEditing(true)
                return
            }
            otpTxt[sender.tag+1].becomeFirstResponder()
        } else {
            if sender.tag == 0 {
                return
            }
            if sender.text == "" {
                otpTxt[sender.tag-1].becomeFirstResponder()
            } else {
                otpTxt[sender.tag+1].becomeFirstResponder()
            }
        }
    }
    
    
}
