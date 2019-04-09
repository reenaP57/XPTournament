//
//  CurrentlyRunningTournamentModel.swift
//  XPTournament
//
//  Created by mac-00011 on 12/03/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 Use:- Model used for store currently running round all detail and this model use in CurrentlyRunningDetailModel
 */
struct CurrentlyRunningRoundDetailModel : Mappable {
    
    var round_no: Int?
    var completedRound: Int?
    var totalPlayers: Int?
    var tournamentType: Int?
    var tournamentId: Int64?
    var id: Int?
    var round: [RoundDetailModel]?

    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        round_no <- map["round_no"]
        completedRound <- map["is_completed_round"]
        totalPlayers <- map["totalPlayers"]
        tournamentType <- map["tournament_type"]
        tournamentId <- map["tournament_id"]
        id <- map["id"]
        round <- map["round"]
    }
}

/*
 Use:- Model used for store all bracket list of particular tournament
 Screen:- BracketViewController
 */
struct CurrentlyRunningDetailModel: Mappable {
    
    var data: [CurrentlyRunningRoundDetailModel]?
    var swissRoundCounts: Int?
    var eliminationRoundCounts: Int?
    var status: Int?
    var message: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        data <- map[CJsonData]
        swissRoundCounts <- map["meta.swissRoundCounts"]
        eliminationRoundCounts <- map["meta.eliminationRoundCounts"]
        status <- map["meta.status"]
        message <- map["meta.message"]
    }
}


