//  NotificationViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 04/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import SwiftMessageBar


class NotificationViewController: UIViewController {
    @IBOutlet weak var notificationTbl:UITableView!
    @IBOutlet weak var lblNotFound:UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        get_notification()
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated:true)
    }
    
    func get_notification() {
        showLoader()
        APIFunc.postAPI("get_notification", ["user_id":signUp!.userID]) { (json,status, message) in
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
                            notificationHealth = try decoder.decode([NotificationHealth].self, from: jsonData)
                            notificationHealth = notificationHealth.reversed()
                            
                            self.notificationTbl.reloadData()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    self.notificationTbl.isHidden = notificationHealth.count == 0 ? true : false
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



extension NotificationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationHealth.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! HomeTableViewCell
        
        let notiData = notificationHealth[indexPath.row]
        cell.timeLbl.text = notiData.date.getElapsedInterval("yyyy-MM-dd HH:mm:ss") //"yyyy/MM/dd HH:mm:ss"
        cell.descLbl.text = notiData.notification
        
        return cell
    }
    
    
    
}
