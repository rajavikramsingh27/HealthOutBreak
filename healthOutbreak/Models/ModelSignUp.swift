//  ModelSignUp.swift
//  healthOutbreak
//  Created by iOS-Appentus on 11/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import Foundation


// MARK: - Signup
struct SignUp: Codable {
    let userID, userName, userProfile, userEmail: String
    let userPassword, userSocial, userCountryCode, userMobile: String
    let userIDCard, userGender, userAge, riskFector: String
    let userLat, userLang, userDeviceType, userDeviceToken: String
    let userStatus, created: String
    let interest: [SelecgedInterest]?
    let travelInfo: [GetTravel]?
    
    
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case userProfile = "user_profile"
        case userEmail = "user_email"
        case userPassword = "user_password"
        case userSocial = "user_social"
        case userCountryCode = "user_country_code"
        case userMobile = "user_mobile"
        case userIDCard = "user_id_card"
        case userGender = "user_gender"
        case userAge = "user_age"
        case riskFector = "risk_fector"
        case userLat = "user_lat"
        case userLang = "user_lang"
        case userDeviceType = "user_device_type"
        case userDeviceToken = "user_device_token"
        case userStatus = "user_status"
        case created, interest
        case travelInfo = "travel_info"
    }
    
}


var signUp:SignUp?

