//  API.swift
//  SheDistrict
//  Created by Appentus Technologies on 1/23/20.
//  Copyright © 2020 appentus. All rights reserved.



import Foundation
import Alamofire
import SwiftMessageBar
import SwiftyJSON


class APIFunc {
    class func getAPIWithoutBaseURL(_ url: String , _ parameters: [String:Any] , completion: @escaping ( _ json:JSON) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let apiURL = url
            let param = parameters
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 80
            
            manager.request(apiURL, method: .get, parameters: param).validate().responseString { (response) in
                switch response.result {
                case .success:
                    let json = JSON(response.data!)
                    completion(json)
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
    
    
    
    class func postAPI(_ url: String , _ parameters: [String:Any] , completion: @escaping ( _ json:JSON,_ status:String,_ message:String) -> ()) {
        if Reachability.isConnectedToNetwork() {
            let apiURL = kBaseURL+url
            let param = parameters
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 80
            
            manager.request(apiURL, method: .post, parameters: param).validate().responseString { (response) in
                switch response.result {
                case .success:
                       let dict_json = response.result.value!.dictionary
                       if dict_json.count > 0 {
                            let json = JSON(dict_json)
                            completion(json,"\(dict_json[status_resp]!)","\(dict_json[message_resp]!)")
                       } else {
                        completion(["status":"failed","message":"Error From API"],"failed","Error From API")
                       }
                    break
                case .failure(let error):
                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
    class func getAPI(_ url: String ,_ parameters: [String:String] ,completion: @escaping( _ json:JSON,_ status:String,_ message:String) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let apiURL = kBaseURL+url
            let param = parameters
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 80
            
            manager.request(apiURL, method: .get, parameters: param).validate().responseString { (response) in
                switch response.result {
                case .success:
                    let json = JSON(response.data!)
                    let dict_json = json.dictionaryObject
                    if dict_json!.count > 0 {
                         let json = JSON(dict_json)
                         completion(json,"\(dict_json![status_resp]!)","\(dict_json![message_resp]!)")
                    } else {
                     completion(["status":"failed","message":"Error From API"],"failed","Error From API")
                    }
                    
                    break
                case .failure(let error):
                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
    class func postAPI_Image(_ url: String,_ imageData: Data?,_ parameters: [String : String],_ img_param:String, completion:@escaping ( _ json:JSON,_ status:String,_ message:String)->()) {
        if Reachability.isConnectedToNetwork() {
            let urlFull = URL (string: kBaseURL+url) /* your API url */
            
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
            
            let manager = Alamofire.SessionManager.default
//            manager.session.configuration.timeoutIntervalForRequest = 80
            
            manager.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imageData {
                    multipartFormData.append(data, withName: img_param, fileName: "image.jpeg", mimeType: "image/jpeg")
                }
            }, usingThreshold: UInt64.init(), to: urlFull!, method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.data!)
                        let dict_json = json.dictionaryObject
                        
                        if dict_json == nil {
                            completion(["status":"failed","message":"Video Not uploaded"],"failed","Video Not uploaded")
                        } else {
                            let json = JSON(dict_json as Any)
                            completion(json,"\(dict_json![status_resp]!)","\(dict_json![message_resp]!)")
                        }
                    }
                case .failure(let error):
                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
                }
            }
        } else {
            func_show_alert()
        }
    }
    
    class func postAPI_Video(_ url: String,_ video_Data: Data?,_ parameters: [String : String],_ video_param:String, completion:@escaping ( _ json:JSON,_ status:String,_ message:String)->()) {
        if Reachability.isConnectedToNetwork() {
            let url = URL (string: kBaseURL+url) /* your API url */
            
            Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
                let timestamp = NSDate().timeIntervalSince1970
                
                multipartFormData.append(video_Data!, withName:video_param, fileName: "\(timestamp).mp4" , mimeType: "video/mp4")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using:.utf8)!, withName: key)
                }
            }, to: url!) { (result) in
                
                switch result {
                case .success(let upload, _ , _):
                    upload.uploadProgress(closure: { (progress) in
                        
                    })
                    upload.responseJSON { response in
                        let json = JSON(response.data!)
                        let dict_json = json.dictionaryObject
                        
                        if dict_json == nil {
                            completion(["status":"failed","message":"Video Not uploaded"],"failed","Video Not uploaded")
                        } else {
                            if dict_json!.isEmpty {
                                completion(["status":"failed","message":"Video Not uploaded"],"failed","Video Not uploaded")
                            } else {
                                completion(json,"\(dict_json![status_resp]!)","\(dict_json![message_resp]!)")
                            }
                        }
                    }
                case .failure(let _):
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
    
    
    class func postAPI_Images(_ url: String,_ arrayImgData: [Data],_ parameters: [String : Any], completion:@escaping ( _ json:JSON,_ status:String,_ message:String)->()) {
        if Reachability.isConnectedToNetwork() {
            let url = URL (string:kBaseURL+url) /* your API url */
            
            let date = NSDate()
            let df = DateFormatter()
            df.dateFormat = "dd-mm-yy-hh-mm-ss"
            
            let imageName = df.string(from: date as Date)
            
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                for i in 0..<arrayImgData.count {
                    multipartFormData.append(arrayImgData[i], withName: "photos[]",fileName: "image.png", mimeType: "image/png")
                }
            }, usingThreshold: UInt64.init(), to: url!, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.data!)
                        let dict_json = json.dictionaryObject
                        if dict_json == nil {
                            completion(["status":"failed","message":"Video Not uploaded"],"failed","Video Not uploaded")
                        } else {
                            completion(json,"\(dict_json![status_resp]!)","\(dict_json![message_resp]!)")
                        }
                    }
                case .failure(let error):
                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
                }
            }
        } else {
            func_show_alert()
        }
    }
    
    class func getAPIUnSplash(_ url: String ,_ parameters: [String:String] ,completion: @escaping([[String:Any]]) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let apiURL = url
            let param = parameters
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 80
            
            let headers: HTTPHeaders = [
                "Authorization": "Client-ID dux3XP6NZJm-n9s0MR6jClid6fz-hsdfCllKd9YccyU"
            ]
            
            manager.request(apiURL, method: .get, parameters: param,headers:headers).validate().responseString { (response) in
                switch response.result {
                case .success:
                    completion(response.result.value!.array)
                    break
                case .failure(let error):
                    completion([["message":error.localizedDescription]])
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
    class func getAPIUnSplashSearch(_ url: String ,_ parameters: [String:String] ,completion: @escaping([[String:Any]]) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let apiURL = url
            let param = parameters
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 80
            
            let headers: HTTPHeaders = [
                "Authorization": "Client-ID dux3XP6NZJm-n9s0MR6jClid6fz-hsdfCllKd9YccyU"
            ]
            
            manager.request(apiURL, method: .get, parameters: param,headers:headers).validate().responseString { (response) in
                switch response.result {
                case .success:
                    let dictUnsplash = response.result.value!.dictionary
                    if let results = dictUnsplash["results"] as? [[String:String]] {
                        completion(results)
                    }
                    
                    break
                case .failure(let error):
                    completion([["message":error.localizedDescription]])
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
}


//class APIFunc {
//    class func postAPI(_ url: String , _ parameters: [String:Any] , completion: @escaping ( _ json:JSON,_ status:String,_ message:String) -> ()) {
//        if Reachability.isConnectedToNetwork() {
//            let apiURL = kBaseURL+url
//            let param = parameters
//
//            let configuration = URLSessionConfiguration.default
//            configuration.timeoutIntervalForRequest = 80
//            let manager = Alamofire.SessionManager(configuration: configuration)
//
////            AF.request(apiURL, method: .post, parameters: param).validate().responseString { (response) in
//            manager.request(apiURL, method: .post, parameters: param).validate().responseString { (response) in
//                switch response.result {
//                case .success:
//                    do {
//                        let json = try JSON (data: response.data!)
//                        let dictJSON = json.dictionaryObject
//                        completion(json,"\(dictJSON![status_resp]!)","\(dictJSON![message_resp]!)")
//                    } catch {
//                        completion(["status":"failed","message":"Error From API"],"failed","Error From API")
//                    }
//                    break
//                case .failure(let error):
//                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
//                    break
//                }
//            }
//        } else {
//            func_show_alert()
//        }
//
//    }
//
//    class func getAPI(_ url: String ,_ parameters: [String:String] ,completion: @escaping( _ json:JSON,_ status:String,_ message:String) -> ()) {
//        if Reachability.isConnectedToNetwork(){
//            let apiURL = kBaseURL+url
//            let param = parameters
//
//            let configuration = URLSessionConfiguration.default
//            configuration.timeoutIntervalForRequest = 80
//            let manager = Alamofire.SessionManager(configuration: configuration)
//
////            AF.request(apiURL, method: .get, parameters: param).validate().responseString { (response) in
//            manager.request(apiURL, method: .get, parameters: param).validate().responseString { (response) in
//                switch response.result {
//                case .success:
//                    do {
//                        let json = try JSON (data: response.data!)
//                        let dictJSON = json.dictionaryObject
//                        completion(json,"\(dictJSON![status_resp]!)","\(dictJSON![message_resp]!)")
//                    } catch {
//                        completion(["status":"failed","message":"Error From API"],"failed","Error From API")
//                    }
//                    break
//                case .failure(let error):
//                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
//                    break
//                }
//            }
//        } else {
//            func_show_alert()
//        }
//
//    }
//
//    class func postAPI_Image(_ url: String,_ imageData: Data?,_ parameters: [String : String],_ img_param:String, completion:@escaping ( _ json:JSON,_ status:String,_ message:String)->()) {
//        if Reachability.isConnectedToNetwork() {
//            let urlFull = URL (string: kBaseURL+url) /* your API url */
//
//            let headers: HTTPHeaders = [
//                "Content-type": "multipart/form-data"
//            ]
//
//            AF.upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in parameters {
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//                }
//
//                if let data = imageData {
//                    multipartFormData.append(data, withName: img_param, fileName: "image.jpeg", mimeType: "image/jpeg")
//                }
//            }, to: urlFull!, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
//                switch response.result {
//                case .success:
//                    do {
//                        let json = try JSON (data: response.data!)
//                        let dictJSON = json.dictionaryObject
//                        completion(json,"\(dictJSON![status_resp]!)","\(dictJSON![message_resp]!)")
//                    } catch {
//                        completion(["status":"failed","message":"Error From API"],"failed","Error From API")
//                    }
//                    break
//                case .failure(let error):
//                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
//                    break
//                }
//            }
//        } else {
//            func_show_alert()
//        }
//    }
//
//    class func postAPI_Video(_ url: String,_ video_Data: Data?,_ parameters: [String : String],_ video_param:String, completion:@escaping ( _ json:JSON,_ status:String,_ message:String)->()) {
//        if Reachability.isConnectedToNetwork() {
//            let url = URL (string: kBaseURL+url) /* your API url */
//
//            AF.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
//                let timestamp = NSDate().timeIntervalSince1970
//
//                multipartFormData.append(video_Data!, withName:video_param, fileName: "\(timestamp).mp4" , mimeType: "video/mp4")
//                for (key, value) in parameters {
//                    multipartFormData.append(value.data(using:.utf8)!, withName: key)
//                }
//            }, to: url!).responseJSON { (response) in
//                switch response.result {
//                case .success:
//                    do {
//                        let json = try JSON (data: response.data!)
//                        let dictJSON = json.dictionaryObject
//                        completion(json,"\(dictJSON![status_resp]!)","\(dictJSON![message_resp]!)")
//                    } catch {
//                        completion(["status":"failed","message":"Error From API"],"failed","Error From API")
//                    }
//                    break
//                case .failure(let error):
//                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
//                    break
//                }
//            }
//        } else {
//            func_show_alert()
//        }
//
//    }
//
//
//
//    class func postAPI_Images(_ url: String,_ arrayImgData: [Data],_ parameters: [String : Any], completion:@escaping ( _ json:JSON,_ status:String,_ message:String)->()) {
//        if Reachability.isConnectedToNetwork() {
//            let url = URL (string:kBaseURL+url) /* your API url */
//
//            let headers: HTTPHeaders = [
//                "Content-type": "multipart/form-data"
//            ]
//
//            AF.upload(multipartFormData: { (multipartFormData) in
//                for (key, value) in parameters {
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//                }
//
//                for i in 0..<arrayImgData.count {
//                    multipartFormData.append(arrayImgData[i], withName: "photos[]",fileName: "image.png", mimeType: "image/png")
//                }
//            }, to: url!, usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON { (response) in
//                switch response.result {
//                case .success:
//                    do {
//                        let json = try JSON (data: response.data!)
//                        let dictJSON = json.dictionaryObject
//                        completion(json,"\(dictJSON![status_resp]!)","\(dictJSON![message_resp]!)")
//                    } catch {
//                        completion(["status":"failed","message":"Error From API"],"failed","Error From API")
//                    }
//                    break
//                case .failure(let error):
//                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
//                    break
//                }
//            }
//        } else {
//            func_show_alert()
//        }
//    }
//
//
//}

func func_show_alert() {
    SwiftMessageBar.showMessage(withTitle: "Error", message:"Internet Connection not Available!", type:.error)
}

func anyConvertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            
        }
    }
    return nil
}

func cleanJsonToObject(_ cleanData : AnyObject) -> AnyObject {
    let jsonObjective : Any = cleanData
    if jsonObjective is NSArray {
        let jsonResult : NSArray = (jsonObjective as? NSArray)!
        
        let array: NSMutableArray = NSMutableArray(array: jsonResult)
        for  i in stride(from: array.count-1, through: 0, by: -1) {
            let a : AnyObject = array[i] as AnyObject;
            
            if a as! NSObject == NSNull(){
                array.removeObject(at: i)
                
            } else {
                array[i] = cleanJsonToObject(a)
            }
        }
        return array;
    } else if jsonObjective is NSDictionary  {
        
        let jsonResult : Dictionary = (jsonObjective as? Dictionary<String, AnyObject>)!
        
        let dictionary: NSMutableDictionary = NSMutableDictionary(dictionary: jsonResult)
        
        //            let dictionary : NSMutableDictionary = (jsonResult as? NSMutableDictionary<String, AnyObject>)!
        
        for  key in dictionary.allKeys {
            
            let  d : AnyObject = dictionary[key as! NSCopying]! as AnyObject
            
            if d as! NSObject == NSNull()
            {
                dictionary[key as! NSCopying] = ""
            }
            else
            {
                dictionary[key as! NSCopying] = cleanJsonToObject(d )
            }
        }
        return dictionary;
    }
    else {
        return jsonObjective as AnyObject;
    }
    
}



enum status_type {
    case error_from_api
    case success
    case fail
}

func return_status(_ resp:[String:Any]) -> status_type {
    if let error = resp["error"] as? Bool{
        return status_type.error_from_api
    }else{
        let status = "\(resp["status"]!)"
        if status == "success"{
            return status_type.success
        }else{
            return status_type.fail
        }
    }
}



