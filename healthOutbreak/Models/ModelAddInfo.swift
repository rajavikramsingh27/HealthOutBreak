//
//  ModelAddInfo.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 13/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import Foundation


// MARK: - GetRiskFectorElement
struct RiskFector: Codable {
    let id, name, created: String
}

var riskFector:[RiskFector] = []
