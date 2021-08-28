//
//  ModelCheck.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 15/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import Foundation


// MARK: - GetDiseaseElement
struct GetDisease: Codable {
    let id, name, created: String
}

var getDisease:[GetDisease] = []



// MARK: - Symtom
struct Symtom: Codable {
    let id, name, icon, created: String
}

var symtoms:[Symtom] = []




// MARK: - Description
struct Description: Codable {
    let title, descriptionDescription: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case descriptionDescription = "description"
    }
}

var descriptionSymtom:Description!



// MARK: - PreventiveElement
struct Preventive: Codable {
    let icon, name: String
}

var preventive:[Preventive] = []



// MARK: - HelpElement
struct Help: Codable {
    let location, name, number: String
}

var help:[Help] = []
