//  InterestViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 07/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar


class InterestViewController: UIViewController {
    @IBOutlet weak var collChhoseYourInterest:UICollectionView!
    @IBOutlet weak var heightColl:NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: RoundButton!
    @IBOutlet weak var viewBack: UIView!
    
//    var arrRistFactors = ["Business","Social Work","Sales","Sports","Business","Social Work","Sales","Sports","Sales"]
    var arrRistFactorSelected = [Bool]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSubmit.isUserInteractionEnabled = true
        
        getInterest.removeAll()
        get_interest()
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    func setData() {
        let interestCount = signUp!.interest?.count ?? 0
        for i in 0..<getInterest.count {
            for j in 0..<interestCount {
                if getInterest[i].name.lowercased() == signUp!.interest![j].interest.lowercased() {
                    arrRistFactorSelected[i] = true
                }
            }
        }
        collChhoseYourInterest.reloadData()
    }
    
    @IBAction func submitBtn(_ sender: RoundButton) {
//        if !arrRistFactorSelected.contains(true) {
//            SwiftMessageBar.showMessage(withTitle: "Error", message: "Select an interest", type:.error)
//        } else {
            update_interest()
//        }
        
    }
    
    func update_interest() {
        showLoader()
        var selectedInterest = ""
        for i in 0..<arrRistFactorSelected.count {
            if arrRistFactorSelected[i] {
                selectedInterest = selectedInterest.isEmpty ? getInterest[i].name : "\(selectedInterest),\(getInterest[i].name)"
            }
        }
                
        let param = ["user_id":signUp!.userID,"intrest":selectedInterest]
        APIFunc.postAPI("update_interest",param) { (json,status, message) in
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
    
    func get_interest() {
        showLoader()
        
        APIFunc.getAPI("get_interest", [:]) { (json,status, message) in
            DispatchQueue.main.async {
                self.dismissLoader()
                
                if json.dictionary == nil {
                    return
                }
                
                let status = return_status(json.dictionaryObject!)
                
                switch status {
                case .success:
                    let decoder = JSONDecoder()
                    if let jsonData = json[result_resp].description.data(using: .utf8) {
                        do {
                            getInterest = try decoder.decode([GetInterest].self, from: jsonData)
                            for _ in getInterest {
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
    
}



extension InterestViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthFinal = collectionView.frame.width/2 - 15
        return CGSize(width: widthFinal, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getInterest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! SignUpAddInfoCollectionCell
        
        let interest =  getInterest[indexPath.row]
        cell.infoLbl.text = interest.name
        cell.tickImg.isHidden = !arrRistFactorSelected[indexPath.row]
        cell.containerView.backgroundColor = arrRistFactorSelected[indexPath.row] ? hexStringToUIColor(hex:"#4C2AB1") : hexStringToUIColor(hex:"#C1C1C1")
        
        heightColl.constant = collectionView.contentSize.height + 20
        self.viewBack.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: collectionView.contentSize.height + 150)
        self.tableView.reloadData()
        
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
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont,str:String) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = str.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
}

