//  AddSymptomsViewController.swift
//  healthOutbreak
//  Created by iOS-Appentus on 20/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import UIKit
import SwiftMessageBar
import Alamofire


var strSelectedDisease = ""
var addSymptomSelected = [String]()


class AddSymptomsViewController: UIViewController {
    @IBOutlet weak var txtRequestType:UITextField!
    @IBOutlet weak var txtTemperature:UITextField!
    @IBOutlet weak var txtAdditionalNotes:UITextField!
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }
    
    @IBAction func btnRequestType(_ sender:UIButton) {
        let alertController = UIAlertController (title:"Select Request", message:"", preferredStyle:.actionSheet)
        
        alertController.addAction(UIAlertAction(title:"Cancel", style:.cancel, handler:nil))
        alertController.addAction(UIAlertAction(title:"I am presenting symptoms.", style:.default, handler:{ action in
            self.txtRequestType.text = "I am presenting symptoms."
        }))
        alertController.addAction(UIAlertAction(title:"I need a test", style:.default, handler:{ action in
            self.txtRequestType.text = "I need a test."
        }))
        
        present(alertController, animated:true, completion:nil)
    }
    
    @IBAction func btnBack(_ sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSend(_ sender:UIButton) {
        if txtRequestType.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter request type", type:.error)
        } else if txtTemperature.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter temperature", type:.error)
        } else if txtAdditionalNotes.text!.isEmpty {
            SwiftMessageBar.showMessage(withTitle: "Error", message:"Enter additional notes", type:.error)
        } else {
            addSymtoms()
        }
        
    }
        
    
    
    func addSymtoms() {
        let headers = [
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlN2M2YTNhODM4NWExNWM3ODFhMjIyMSIsImlhdCI6MTU4NTgxNzY2NH0.XK5lfCndqWIvSrrIDUZQVsqQrZeqw14z7Hwivz_Yck0",
          "Content-Type": "application/json",
          "cache-control": "no-cache",
          "Postman-Token": "7c4bd32e-3adf-4a00-9875-3fd11642259f"
        ]
        
        var strAge = 0
        let age = signUp!.userAge.components(separatedBy: " ")
        if age.count > 0 {
            strAge = Int(age[0])!
        }
        
        showLoader()
        let parameters = [
            "name":signUp!.userName,
            "age":strAge,
            "deviceToken":kTokenFireBase,
            "outbreak":strSelectedDisease,
            "symptoms":addSymptomSelected,
            "video":"https://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
            "requestType":txtRequestType.text!,
            "temperature":txtTemperature.text!,
            "notes":txtAdditionalNotes.text!,
            "uId":signUp!.userID
            ] as [String : Any]
        print(parameters)
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string:kBaseURLAssesment+"assesment")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData!
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.dismissLoader()
                if (error != nil) {
                    print(error.debugDescription)
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with:data!, options:.allowFragments) as! [String:Any]
                        print(json)
                        if let success = json["success"] as? String {
                            if success.lowercased() == "ok".lowercased() {
                                SwiftMessageBar.showMessage(withTitle: "Success", message:"Symptoms are added successfully", type:.success)
                                self.navigationController?.popViewController(animated:true)
                            } else {
                                SwiftMessageBar.showMessage(withTitle: "Success", message:"Something went wrong", type:.error)
                            }
                        } else {
                            SwiftMessageBar.showMessage(withTitle: "Success", message:"Something went wrong", type:.error)
                        }
                    } catch {
                        SwiftMessageBar.showMessage(withTitle: "Success", message:"Something went wrong", type:.error)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func arrayto_json(var_arr:[String]) -> String {
      let jsonData = try! JSONSerialization.data(withJSONObject: var_arr, options: JSONSerialization.WritingOptions.prettyPrinted)
      let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
      print(jsonString)
      return jsonString
    }
    
}
