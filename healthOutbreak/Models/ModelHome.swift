//  File.swift
//  healthOutbreak
//  Created by iOS-Appentus on 16/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import Foundation


// MARK: - Statistic
struct Statistic: Codable {
    let id: String
    let caseType: String //CaseType
    let caseDisease: String //CaseDisease
    let created, lat, lng, userID: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case caseType = "case_type"
        case caseDisease = "case_disease"
        case created, lat, lng
        case userID = "user_id"
        case status
    }
}



var statistics:[Statistic] = []

// MARK: - Counts
struct Counts: Codable {
    let deathCount, confirmCount, recoverCount: String
    
    enum CodingKeys: String, CodingKey {
        case deathCount = "death_count"
        case confirmCount = "Confirm_count"
        case recoverCount = "recover_count"
    }
}


var counts:Counts!

