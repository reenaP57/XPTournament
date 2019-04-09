//
//  UpcomingMatchesModel.swift
//  XPTournament
//
//  Created by mac-00010 on 19/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
    Use:- Model used for store particular upcoming matches detail and this model use in UpcomingMatchesModel
*/
struct UpcomingMatchesDetailModel : Mappable {
    
    var id: Int64?
    var title: String?
    var tournament_id: Int64?
    var user_id_one: Int64?
    var user_id_two: Int64?
    var full_name_one: String?
    var full_name_two: String?
    var image_one: String?
    var image_two: String?
    var rating_one: Int?
    var rating_two: Int?
    var round_no: Int?
    var sos_one: Int?
    var sos_two: Int?
    var table_no: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        tournament_id <- map["tournament_id"]
        user_id_one <- map["user_matches.user_id_one"]
        user_id_two <- map["user_matches.user_id_two"]
        full_name_one <- map["user_matches.full_name_one"]
        full_name_two <- map["user_matches.full_name_two"]
        image_one <- map["user_matches.image_one"]
        image_two <- map["user_matches.image_two"]
        rating_one <- map["user_matches.rating_one"]
        rating_two <- map["user_matches.rating_two"]
        round_no <- map["user_matches.round_no"]
        sos_one <- map["user_matches.sos_one"]
        sos_two <- map["user_matches.sos_two"]
        table_no <- map["user_matches.table_no"]
    }
}

/*
    Use:- Model used for store all upcoming matches list
    Screen:- UpcomingMatchViewController
*/
struct UpcomingMatchesModel : Mappable {
    
    var data: [UpcomingMatchesDetailModel]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        data <- map[CJsonData]
    }
}
