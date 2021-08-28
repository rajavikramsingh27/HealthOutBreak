//  CheckViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 04/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar


class CheckViewController:BaseViewController {
    @IBOutlet weak var collDesieseList:UICollectionView!
    @IBOutlet weak var btnMenu:UIButton!
    
    var disease_id = ""
    var symtomSelected = ""
    
    
//    var arrRistFactors = ["Covid","Ebola","Swine Flu","Flu"]
    var arrRistFactorSelected = [Bool]()
    
    @IBOutlet weak var collPersonList:UICollectionView!
//    var arrSymptoms = ["Tiredness","Aches & Pains","Dry Cough","Sore Throat","Vomiting","Runny Nose","Diarrhea","Nasal Congestion"]
//    var arrSymptomsIcons = ["Group 1831.png","Group 1832.png","Group 1834.png","Group 1833.png","Group 1835.png","Group 1836.png","Group 1837.png","Group 1838.png"]
    
    var arrSymptomsSelected = [Bool]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        collDesieseList.delegate = self
        collDesieseList.dataSource = self
        
        collPersonList.delegate = self
        collPersonList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        disease_id = ""
        arrRistFactorSelected.removeAll()
        getDisease.removeAll()
        symtoms.removeAll()
        arrRistFactorSelected.removeAll()
        arrSymptomsSelected.removeAll()
                
        self.tabBarController?.tabBar.isHidden = false
        let allItems = self.tabBarController?.tabBar.items!
        for i in 0..<allItems!.count{
            allItems![i].title = ""
            if i == 1{ allItems![i].title = "Check"}
        }

        get_disease()
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    @IBAction func btnCheck(_ sender:UIButton) {
        if disease_id.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Select a disease", type:.error)
        }/* else if !arrSymptomsSelected.contains(true) {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Select a symtoms", type:.error)
        } */ else {
            check_disease()
        }
        
    }
        
    func get_disease() {
        showLoader()
        APIFunc.getAPI("get_disease", [:]) { (json,status, message) in
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
                            getDisease = try decoder.decode([GetDisease].self, from: jsonData)
                            if let jsonData = json["symtoms"].description.data(using: .utf8) {
                                symtoms = try decoder.decode([Symtom].self, from: jsonData)
                            }
                                                        
                            for _ in getDisease {
                                self.arrRistFactorSelected.append(false)
                            }
                            self.collDesieseList.reloadData()
                            
                            for _ in symtoms {
                                self.arrSymptomsSelected.append(false)
                            }
                            
                            self.collPersonList.reloadData()
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
    
    
    
    func check_disease() {
        for i in 0..<arrSymptomsSelected.count {
            if arrSymptomsSelected[i] {
                addSymptomSelected.append(symtoms[i].name)
            }
            
            symtomSelected = arrSymptomsSelected[i] ? symtoms[i].name : "\(symtomSelected),\(symtoms[i].name)"
        }
                
        let param = [
            "user_id":signUp!.userID,
            "disease_id":disease_id,
            "symtoms":symtomSelected
        ]
        
        showLoader()
        APIFunc.postAPI("check_disease",param) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json["description"].description.data(using: .utf8) {
                        do {
                            descriptionSymtom = try decoder.decode(Description.self, from: jsonData)
                            if let jsonData = json["preventive"].description.data(using: .utf8) {
                                preventive = try decoder.decode([Preventive].self, from: jsonData)
                            } else {
                                preventive.removeAll()
                            }
                            
                            if let _ = json["help"].arrayObject {
                                if let jsonData = json["help"].description.data(using: .utf8) {
                                    help = try decoder.decode([Help].self, from: jsonData)
                                }
                            } else {
                                help.removeAll()
                            }
                            
                            if !self.arrSymptomsSelected.contains(true) {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier:"AsymptomaticViewController") as! AsymptomaticViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                if message.lowercased() == "Symptomatic".lowercased() {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"SymptomaticViewController") as! SymptomaticViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"AsymptomaticViewController") as! AsymptomaticViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
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



extension CheckViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collDesieseList {
            let size = getDisease[indexPath.row].name.sizeText(UIFont(name:"Rockwell", size:16.0)!)
            let widht = size.width+CGFloat(50)
            return CGSize (width:widht, height:45)
        } else {
            let widht = collPersonList.frame.size.width/2-10
            return CGSize (width:widht, height:50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collDesieseList {
            return getDisease.count
        } else {
            return symtoms.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collDesieseList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! SignUpAddInfoCollectionCell
            
            cell.infoLbl.text = getDisease[indexPath.row].name
            cell.containerView.backgroundColor = arrRistFactorSelected[indexPath.row] ? hexStringToUIColor(hex:"#4C2AB1") : hexStringToUIColor(hex:"#C1C1C1")
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell-1", for: indexPath) as! CheckCollectionViewCell
             
            cell.infoLbl.text = symtoms[indexPath.row].name
            cell.containerView.backgroundColor = arrSymptomsSelected[indexPath.row] ? hexStringToUIColor(hex:"#FFD500") : UIColor.white
            cell.containerView.layer.borderWidth = arrSymptomsSelected[indexPath.row] ? 0 : 1
            
            cell.tickImg.isHidden = !arrSymptomsSelected[indexPath.row]
            cell.personImg.isHidden = arrSymptomsSelected[indexPath.row]
                
            cell.personImg.sd_setImage(with: URL(string:symtoms[indexPath.row].icon.userProfile), placeholderImage: UIImage(named:""))
            
            cell.btnSelect.tag = indexPath.row
            cell.btnSelect.addTarget(self, action:#selector(btnSelect(_:)), for:.touchUpInside)
            
            return cell
        }
    }
    
    @IBAction func btnSelect(_ sender:UIButton ) {
        for i in 0..<symtoms.count {
            if i == sender.tag {
                if arrSymptomsSelected[i] {
                    arrSymptomsSelected[i] = false
                } else {
                    arrSymptomsSelected[i] = true
                }
            }
        }
        collPersonList.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        disease_id = getDisease[indexPath.row].id
        strSelectedDisease = getDisease[indexPath.row].name
        
        if collectionView == collDesieseList {
            for i in 0..<arrRistFactorSelected.count {
                if i == indexPath.row {
                    arrRistFactorSelected[i] = true
                } else {
                    arrRistFactorSelected[i] = false
                }
            }
            collDesieseList.reloadData()
        }
        
    }
    
    
    
}

