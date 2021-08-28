//  ModelGetInterest.swift
//  healthOutbreak
//  Created by iOS-Appentus on 13/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import Foundation


struct GetInterest : Codable {
    let id, name, created: String
}


var getInterest:[GetInterest] = []

struct SelecgedInterest : Codable {
    let id, interest, created: String
    let userID:String?
    
    enum CodingKeys: String, CodingKey {
        case id, interest
        case userID = "user_id"
        case created
    }
}


var selecgedInterest:[SelecgedInterest] = []

