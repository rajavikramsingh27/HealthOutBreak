//  SettingVerifyPhoneNumber.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit


class SettingVerifyPhoneNumber: UIViewController,UITextFieldDelegate {
    @IBOutlet var otpTxt:[UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<otpTxt.count {
            otpTxt[i].keyboardType = .numberPad
            otpTxt[i].delegate = self
            otpTxt[i].tag = i
            otpTxt[i].addTarget(self, action:#selector(textField(_:)), for:.editingChanged)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
    @IBAction func btnChange(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendNewCode(_ sender:UIButton) {
        
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVerify(_ sender:UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTravelInfoVC") as! AddTravelInfoVC
//        self.navigationController?.pushViewController(vc, animated: true)
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
