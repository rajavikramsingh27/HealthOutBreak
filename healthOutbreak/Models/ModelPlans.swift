//
//  ModelPlans.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 14/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import Foundation


struct GetTravel: Codable {
    let id, userID, fromWhere, toWhere: String
    let startDate, endDate, placeStay, perpose: String
    let isNotify, created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case fromWhere = "from_where"
        case toWhere = "to_where"
        case startDate = "start_date"
        case endDate = "end_date"
        case placeStay = "place_stay"
        case perpose
        case isNotify = "is_notify"
        case created
    }
}

var getTravel:[GetTravel] = []
var historyGetTravel:[GetTravel] = []

