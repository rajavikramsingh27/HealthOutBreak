
//  ModelGlobalStatistics.swift
//  healthOutbreak
//  Created by iOS-Appentus on 20/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.


import Foundation


struct GlobalStatisticData: Codable {
    let date: String
    let cases, recovered, deaths: Int
}

var globalStatisticData:[GlobalStatisticData] = []
var globalStatisticProjected:[GlobalStatisticData] = []


