//
//  NotificationModel.swift
//  XPTournament
//
//  Created by mac-00011 on 06/03/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 Use:- Model used for store CMS data
 Screen:- CMSViewController
 */
struct NotificationModel : Mappable {
    
    var id: Int64?
    var tournament_id: Int64?
    var user_id :Int64?
    var message: String?
    var image: String?
    var isRead: Int?
    var time: Int?
    var status: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        tournament_id <- map["tournament_id"]
        user_id <- map["user_id"]
        message <- map["message"]
        image <- map["image"]
        isRead <- map["isRead"]
        image <- map["image"]
        time <- map["time"]
        status <- map["status"]
    }
    
}

struct NotificationListModel : Mappable {
    
    var data: [NotificationModel]?
    var current_page: Int64?
    var from: Int64?
    var last_page: Int64?
    var path: String?
    var per_page: Int64?
    var to: Int64?
    var total: Int64?
    var status: Int64?
    var message: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        data <- map[CJsonData]
        current_page <- map["meta.current_page"]
        from <- map["meta.from"]
        last_page <- map["meta.last_page"]
        path <- map["meta.path"]
        per_page <- map["meta.per_page"]
        to <- map["meta.to"]
        total <- map["meta.total"]
        status <- map["meta.status"]
        message <- map["meta.message"]
    }
}

