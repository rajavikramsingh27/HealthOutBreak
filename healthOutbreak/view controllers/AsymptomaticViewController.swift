//
//  AsymptomaticViewController.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class AsymptomaticViewController: UIViewController {
    @IBOutlet weak var tblAsymptomatic:UITableView!
    @IBOutlet weak var HeightTblAsymptomatic:NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDescriptio:UILabel!
    
    
//    let arrAsymptomaticTitle = ["Wash your hands","Use an alcohol-based hand sanitizer","Avoid touching your eyes, nose and mouth","Cover your cough or sneeze with a tissue","Avoid contact with sick people"]
//    let arrAsymptomaticIcon = ["Group 1848.png","Group 1849.png","Group 1850.png","Group 1851.png","Group 1852.png"]
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}



extension AsymptomaticViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preventive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for:indexPath) as! HomeTableViewCell
                
        let prevData = preventive[indexPath.row]
        cell.descLbl.text = prevData.name
        cell.iconImg.sd_setImage(with: URL(string:prevData.icon.userProfile), placeholderImage: UIImage(named:""))
                
        return cell
    }
    
    @IBAction func selectButton(_ sender:UIButton) {
        
    }
    
}
