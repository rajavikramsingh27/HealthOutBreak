//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SDWebImage

class MenuViewController: UIViewController {
    @IBOutlet var imgProfileImage:UIImageView!
    @IBOutlet var lblUserName:UILabel!
    @IBOutlet var lblEmail:UILabel!
    
    @IBOutlet var tblMenuOptions : UITableView!
    
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    var arrayMenuTitle = ["Notificaion","News","Add Case","Interests","Risk Factors","About","Contact","","Log Out"]
    var arrayMenuIcon = ["Union 4.png","Path 1212.png","Group 1631.png","Group 1799.png","Group 1801.png","Group 1823.png","Union 2.png","","Union 6.png"]
    
    var arrSelect = [Bool]()
    var btnMenu : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblMenuOptions.tableFooterView = UIView()
        if let savedSelection = UserDefaults.standard.object(forKey: "sidemenuSelection") as? [Bool]{
            arrSelect = savedSelection
        }else{
            for _ in arrayMenuIcon {
                arrSelect.append(false)
            }
        }
        self.tblMenuOptions.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imgProfileImage.sd_setImage(with: URL(string:signUp!.userProfile.userProfile), placeholderImage:kDefaultUser)
        lblUserName.text = signUp!.userName
        lblEmail.text = signUp!.userEmail
        
        updateArrayMenuOptions()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        slideMenuController()?.closeLeft()
        slideMenuItemSelectedAtIndex(Int32(button!.tag))
    }
    
    
}


extension MenuViewController:UITableViewDelegate,UITableViewDataSource {
    
    @IBAction func btnProfile(_ sender: UIButton) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = 100
        self.onCloseMenuClick(btn)
    }
    
    func updateArrayMenuOptions(){
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let bgView = cell.contentView.viewWithTag(1) as! UIView
        
        bgView.isHidden = !arrSelect[indexPath.row]
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named:arrayMenuIcon[indexPath.row])
        lblTitle.text = arrayMenuTitle[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<arrayMenuIcon.count {
            if i == indexPath.row {
                arrSelect[i] = true
            } else {
                arrSelect[i] = false
            }
        }

        UserDefaults.standard.set(arrSelect, forKey: "sidemenuSelection")
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
        tblMenuOptions.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuTitle.count
    }
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        
        
        switch(index) {
        case 100:
            self.openViewControllerBasedOnIdentifier("ProfileViewController")
            break
        case 0:
            self.openViewControllerBasedOnIdentifier("NotificationViewController")
            break
        case 1:
            self.openViewControllerBasedOnIdentifier("NewsViewController")
            break
        case 2:
            self.openViewControllerBasedOnIdentifier("AddCaseViewController")
            break
        case 3:
            self.openViewControllerBasedOnIdentifier("InterestViewController")
            break
        case 4:
            self.openViewControllerBasedOnIdentifier("RistFactorsViewController")
            break
        case 5:
            self.openViewControllerBasedOnIdentifier("AboutViewController")
            break
        case 6:
            self.openViewControllerBasedOnIdentifier("ContactViewController")
            break
        case 7:
            print("Empty")
            break
        case 8:
            logOut()
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func logOut() {
        let alertVC = UIAlertController (title:"Are you sure ?", message:"Do you want to log out ?", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title:"Cancel", style:.cancel, handler: nil))
         alertVC.addAction(UIAlertAction(title:"Log Out", style:.default, handler: { logout in
            
            UserDefaults.standard.removeObject(forKey:k_user_detals)
            
            let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier:"loginViewController") as! loginViewController
            let navigationViewController: UINavigationController = UINavigationController(rootViewController:sideMenuViewController)
            let appedl = UIApplication.shared.delegate as! AppDelegate
            appedl.window?.rootViewController = navigationViewController
            navigationViewController.navigationBar.isHidden = true
            
            appedl.window?.makeKeyAndVisible()
        }))
        
        present(alertVC, animated:true, completion: nil)
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String) {
        let customTabBar = slideMenuController()?.mainViewController as! UINavigationController
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        customTabBar.pushViewController(destViewController, animated: true)
    }
    
}


