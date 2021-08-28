//
//  ModelNews.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 15/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import Foundation



// MARK: - NewsElement
struct NewsList: Codable {
    let id, source, title, newsDescription: String
    let url: String
    let urlImage: String
    let content, published: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case source = "Source"
        case title = "Title"
        case newsDescription = "Description"
        case url = "URL"
        case urlImage = "URLImage"
        case content = "Content"
        case published = "Published"
    }
}

var newsList:[NewsList] = []

