//  PlansViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit


class PlansViewController:BaseViewController {
    @IBOutlet var planOption:[UIButton]!
    @IBOutlet weak var leadPlanOption:NSLayoutConstraint!
    @IBOutlet weak var btnMenu:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(func_set_selected(noti:)),name:NSNotification.Name(rawValue:"selected_events"), object: nil)
        
        for i in 0..<planOption.count {
            planOption[i].tag = i
            planOption[i].addTarget(self, action:#selector(planOption(_:)), for:.touchUpInside)
            
            if i == 0 {
                planOption[i].setTitleColor(UIColor.black, for:.normal)
                leadPlanOption.constant = planOption[i].frame.origin.x
                UIView.animate(withDuration:0.2) {
                    self.view.layoutIfNeeded()
                }
            } else {
                planOption[i].setTitleColor(hexStringToUIColor(hex: "#B5B5B5"), for:.normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        let allItems = self.tabBarController?.tabBar.items!
        
        for i in 0..<allItems!.count{
            allItems![i].title = ""
            if i == 3 {
                allItems![i].title = "Plans"
            }
        }
    }
     
    @IBAction func openMenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    @objc func func_set_selected(noti:Notification)  {
        let selected_tag = noti.object as! Int
        print(selected_tag)
        
        for i in 0..<planOption.count {
            planOption[i].tag = i
            planOption[i].addTarget(self, action:#selector(planOption(_:)), for:.touchUpInside)
            
            if i == selected_tag {
                planOption[i].setTitleColor(UIColor.black, for:.normal)
                leadPlanOption.constant = planOption[i].frame.origin.x
                UIView.animate(withDuration:0.2) {
                    self.view.layoutIfNeeded()
                }
            } else {
                planOption[i].setTitleColor(hexStringToUIColor(hex: "#B5B5B5"), for:.normal)
            }
        }
        
    }
    
    
    
    @IBAction func planOption(_ sender:UIButton) {
        for i in 0..<planOption.count {
            planOption[i].tag = i
            planOption[i].addTarget(self, action:#selector(planOption(_:)), for:.touchUpInside)
            
            if i == sender.tag {
                planOption[i].setTitleColor(UIColor.black, for:.normal)
                leadPlanOption.constant = planOption[i].frame.origin.x
                UIView.animate(withDuration:0.2) {
                    self.view.layoutIfNeeded()
                }
            } else {
                planOption[i].setTitleColor(hexStringToUIColor(hex: "#B5B5B5"), for:.normal)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"move_by_buttons_events"), object: sender.tag)
    }
        
    @IBAction func btnAddPlans(_ sender:UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"AddPlansViewController") as! AddPlansViewController
        vc.strHeader = "Add Plans"
        navigationController?.pushViewController(vc, animated:true)
    }
    
    
}


