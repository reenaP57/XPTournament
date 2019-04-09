//
//  TournamentBracketModel.swift
//  XPTournament
//
//  Created by mac-00010 on 19/02/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
    Use:- Model used for players detail of particluar round and this model use in TournamentBracketRoundDetailModel
*/
struct TournamentBracketDetailModel : Mappable {
    
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
    var user_id_one_status: String?
    var user_id_two_status: String?
    var table_no: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        tournament_id <- map["tournament_id"]
        user_id_one <- map["user_id_one"]
        user_id_two <- map["user_id_two"]
        full_name_one <- map["full_name_one"]
        full_name_two <- map["full_name_two"]
        image_one <- map["image_one"]
        image_two <- map["image_two"]
        rating_one <- map["ating_one"]
        rating_two <- map["rating_two"]
        round_no <- map["round_no"]
        sos_one <- map["sos_one"]
        sos_two <- map["sos_two"]
        user_id_one_status <- map["user_id_one_status"]
        user_id_two_status <- map["user_id_two_status"]
        table_no <- map["table_no"]
    }
}

/*
    Use:- Model used for store bracket list round all detail and this model use in TournamentBracketModel
*/
struct TournamentBracketRoundDetailModel : Mappable {
   
    var round: [TournamentBracketDetailModel]?
    var completedCount: Int?
    var onGoingCount: Int?
    var totalPlayers: Int?
    var totalRounds: Int?
    var tournamentId: Int64?
    var tournamentType: Int?
    var isCompletedRound: Bool?
    var round_no: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        round <- map["round"]
        completedCount <- map["completedCount"]
        onGoingCount <- map["onGoingCount"]
        totalPlayers <- map["totalPlayers"]
        totalRounds <- map["totalRounds"]
        tournamentId <- map["tournamentId"]
        tournamentType <- map["tournamentType"]
        isCompletedRound <- map["is_completed_round"]
        round_no <- map["round_no"]
    }
}

/*
    Use:- Model used for store all bracket list of particular tournament
    Screen:- BracketViewController
*/
struct TournamentBracketModel: Mappable {
    
    var data: [TournamentBracketRoundDetailModel]?
    var isEliminationMatch: Bool?
    var totalRound: Int?
    var totalPlayer: Int?
    var eliminationRoundCounts: Int?
    var swissRoundCounts: Int?
    var url: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        data <- map[CJsonData]
        totalRound <- map["meta.totalRound"]
        totalPlayer <- map["meta.totalPlayer"]
        isEliminationMatch <- map["meta.isElimination"]
        eliminationRoundCounts <- map["meta.eliminationRoundCounts"]
        swissRoundCounts <- map["meta.swissRoundCounts"]
        url <- map["meta.url"]
    }
}

