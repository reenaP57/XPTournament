//
//  ScoreCardModel.swift
//  XPTournament
//
//  Created by mac-00010 on 19/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
    Use:- Model used for store detail of particular Score and use in ScoreCardModel
*/
struct ScoreCardListDetailModel : Mappable {
    
    var table_no: Int?
    var tournament_type: Int?
    var full_name_one: String?
    var full_name_two: String?
    var other_user_id: Int64?
    var image_one: String?
    var image_two: String?
    var rating_one: Int?
    var rating_two: Int?
    var round_no: Int?
    var sos_one: Int?
    var sos_two: Int?
    var user_id_one_status: String?
    var user_id_two_status: String?
    var user_id_one: Int?
    var user_id_two: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        table_no <- map["table_no"]
        tournament_type <- map["tournament_type"]
        other_user_id <- map["id"]
        full_name_one <- map["full_name_one"]
        full_name_two <- map["full_name_two"]
        image_one <- map["image_one"]
        image_two <- map["image_two"]
        rating_one <- map["rating_one"]
        rating_two <- map["rating_two"]
        round_no <- map["round_no"]
        sos_one <- map["sos_one"]
        sos_two <- map["sos_two"]
        user_id_one_status <- map["user_id_one_status"]
        user_id_two_status <- map["user_id_two_status"]
        user_id_one <- map["user_id_one"]
        user_id_two <- map["user_id_two"]
    }
}

/*
    Use:- Model used for store all Score card list for particular tournament
    Screen:- ScoreCardViewController
*/
struct ScoreCardModel : Mappable {
    
    var login_user_id: Int64?
    var email: String?
    var full_name: String?
    var image: String?
    var total_rating: Int?
    var total_sos: Int?
    var score_card : [ScoreCardListDetailModel]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        login_user_id <- map["id"]
        email <- map["email"]
        full_name <- map["full_name"]
        image <- map["image"]
        total_rating <- map["rating"]
        total_sos <- map["sos"]
        score_card <- map["score_card"]
    }
}
