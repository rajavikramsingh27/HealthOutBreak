//
//  ModelNotification.swift
//  healthOutbreak
//
//  Created by iOS-Appentus on 15/April/2020.
//  Copyright © 2020 Appentus Technologies Pvt. Ltd. All rights reserved.
//

import Foundation


// MARK: - Notification
struct NotificationHealth: Codable {
    let id, notification, created, date: String
}

var notificationHealth:[NotificationHealth] = []
