//
//  TournamentDetailModel.swift
//  XPTournament
//
//  Created by mac-00010 on 19/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 Use:- Model used for store Completed And Live round detail this is used in CompletedAndLiveRoundModel
 */

struct RoundDetailModel: Mappable {
    
    var id: Int?
    var tournament_id: Int?
    var user_id_one: Int?
    var user_id_two: Int?
    var full_name_one: String?
    var full_name_two: String?
    var image_one: String?
    var image_two: String?
    var rating_one: Int?
    var rating_two: Int?
    var round_no: Int?
    var sos_one: Int?
    var sos_two: Int?
    var user_id_one_status: String?
    var user_id_two_status: String?
    var is_user_id_one: Int?
    var is_user_id_two: Int?
    var status: Int?
    var duration: String?
    var table_no: Int?
    var tournament_type: Int?
    var is_start: Int?
    var timeToShow = "00:00:00"
    var toHidePauseAndCallJudge = false
    var is_editable: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        tournament_id <- map["tournament_id"]
        user_id_one <- map["user_id_one"]
        user_id_two <- map["user_id_two"]
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
        is_user_id_one <- map["is_user_id_one"]
        is_user_id_two <- map["is_user_id_two"]
        duration <- map["duration"]
        timeToShow <- map["duration"]
        status <- map["status"]
        table_no <- map["table_no"]
        tournament_type <- map["tournament_type"]
        is_start <- map["is_start"]
        is_editable <- map["is_editable"]
    }
    
    var timerIncrementSeconds = 0
    
    
    var durationInSeconds:Int {
        if let durations = duration {
            let arrTimes = durations.components(separatedBy: ":")
            if arrTimes.count > 2 {
                let hour = arrTimes[0].toInt ?? 0
                let mint = arrTimes[1].toInt ?? 0
                let second = arrTimes[2].toInt ?? 0
                return (hour * 60 * 60) + (mint * 60) + second
            }
            
            return 0
        }
        return 0
    }
}

/*
 Use:- Model used for store completed and Live Match round for Particular tournament
 Screen:- MyTournamentDetailsViewController
 */

struct CompletedAndLiveRoundModel: Mappable {
    
    
    var data: [RoundDetailModel]?
    var eliminationRoundCounts: Int?
    var swissRoundCounts: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        data <- map[CJsonData]
        swissRoundCounts <- map["meta.swissRoundCounts"]
        eliminationRoundCounts <- map["meta.eliminationRoundCounts"]
    }
}
