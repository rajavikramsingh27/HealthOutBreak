//  PlanListViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 06/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar


class PlanListViewController: UIViewController {
    @IBOutlet weak var tblPlanList:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        getTravel.removeAll()
        tblPlanList.reloadData()
        get_travel_data()
    }
        
    func get_travel_data() {
        let param = ["user_id":signUp!.userID]
        print(param)
        
        showLoader()
        APIFunc.postAPI("get_travel_data", param) { (json,status, message) in
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
                            getTravel = try decoder.decode([GetTravel].self, from: jsonData)
                            
                            let arrGetTravel = getTravel
                            getTravel.removeAll()
                            
                            for getTravelData in arrGetTravel {
                                let dateEndDate = getTravelData.startDate.dateFromString("dd/MM/yyyy")
                                
                                let diffInDays = Calendar.current.dateComponents([.day], from:Date(), to:dateEndDate).day
                                if diffInDays! < 0 {
                                    
                                } else {
                                    getTravel.append(getTravelData)
                                }
                            }
                                                            
                            self.tblPlanList.reloadData()
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



extension PlanListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getTravel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! PlanListTableViewCell
        
        let data = getTravel[indexPath.row]
        
        cell.lblFrom.text = data.fromWhere
        cell.lblTo.text = data.toWhere
        cell.lblStartDate.text = data.startDate
        cell.lblEndDate.text = data.endDate
        cell.lblplace_stay.text = data.placeStay
        cell.btnPurpose.setTitle(data.perpose, for: .normal)
        
        let maxWidth = self.view.frame.size.width/2-40
        cell.widhtPurpose.constant = data.perpose.sizeAccordingText(maxWidth, UIFont (name:"NunitoSans-Bold", size: 12)!).width+40
        
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(btnSelect(_:)), for:.touchUpInside)
        
        return cell
    }
    
    @IBAction func btnSelect(_ sender:UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"AddPlansViewController") as! AddPlansViewController
        vc.strHeader = "Upcoming"
        vc.selectedTravelData = getTravel[sender.tag]
        navigationController?.pushViewController(vc, animated:true)
    }
    
    
    
}
