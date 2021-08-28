//  ProfileViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 07/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var imgGendar:UIImageView!
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblAge:UILabel!
    @IBOutlet weak var lblGender:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblPhoneNumber:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 5
        imgProfile.layer.borderColor = hexStringToUIColor(hex:"FFD500").cgColor
        imgProfile.clipsToBounds = true
    }
    
    func setData() {
        imgProfile.sd_setImage(with: URL(string:signUp!.userProfile.userProfile), placeholderImage:kDefaultUser)
        lblName.text = signUp!.userName
        lblAge.text = signUp!.userAge
        lblGender.text = signUp!.userGender
        imgGendar.image = signUp!.userGender.lowercased() == "male" ? UIImage (named:"Male.png") : UIImage (named:"Female.png")
        lblEmail.text = signUp!.userEmail
        lblPhoneNumber.text = "\(signUp!.userCountryCode)-\(signUp!.userMobile)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        setData()
    }
    
    @IBAction func btnEditProfile(_ sender:UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier:"EditProfileViewController") as! EditProfileViewController
        navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnChangePWD(_ sender:UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier:"ChangePasswordViewController") as! ChangePasswordViewController
        navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack(_ sender:UIButton)  {
        navigationController?.popViewController(animated:true)
    }

}
