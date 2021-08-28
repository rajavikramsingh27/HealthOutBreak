//  ModelAddSymptoms.swift
//  healthOutbreak
//  Created by iOS-Appentus on 21/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.



import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation



class ModelAddSymptoms {
    class func postAPI(_ url:String,_ headers:[String:String],_ parameters: [String:Any] , completion: @escaping (_ message:[String:Any]) -> ()) {
        if Reachability.isConnectedToNetwork() {
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string:kBaseURLAssesment+url)! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData!
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                DispatchQueue.main.async {
                    if (error != nil) {
                        print(error.debugDescription)
                    } else {
                        do {
                            let json = try JSONSerialization.jsonObject(with:data!, options:.allowFragments) as! [String:Any]
                            completion(json)
                        } catch {
                            completion(["fail":"Error"])
                        }
                    }
                }
            })
            dataTask.resume()
        } else {
            func_show_alert()
        }
        
    }
        
    class func getNeartestHospital(_ cordinate:CLLocationCoordinate2D,completion: @escaping ( _ response:[String:Any]) -> ()) {
        if Reachability.isConnectedToNetwork() {
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 80
            
            let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(cordinate.latitude),\(cordinate.longitude)&radius=1500&type=hospital&keyword=hospital&key=\(apiGoogleKey)"
            manager.request(url, method: .get).validate().responseString { (response) in
                switch response.result {
                case .success:
                    let dict_json = response.result.value!.dictionary
                    print(dict_json)
                    completion(dict_json)
                    break
                case .failure(let error):
                    completion(["status":"failed","message":"\(error.localizedDescription)"])
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
    class func getNumberFromPlaceID(_ place_id:String,completion: @escaping ( _ response:[String:Any]) -> ()) {
        if Reachability.isConnectedToNetwork() {
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 80
            
            let url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(place_id)&fields=name,rating,formatted_phone_number&key=\(apiGoogleKey)"
            
            manager.request(url, method: .get).validate().responseString { (response) in
                switch response.result {
                case .success:
                    let dict_json = response.result.value!.dictionary
                    print(dict_json)
                    completion(dict_json)
                    break
                case .failure(let error):
                    completion(["status":"failed","message":"\(error.localizedDescription)"])
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
}
