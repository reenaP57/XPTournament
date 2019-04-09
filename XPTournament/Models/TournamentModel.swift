//
//  TournamentModel.swift
//  XPTournament
//
//  Created by mac-00010 on 18/01/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
    Use:- Model used for store tournament detail this is used in TournamentModel and TournamentListModel
*/
struct TournamentDetailModel : Mappable {
    
    var id: Int64?
    var image: String?
    var tournamentType: Int?
    var title: String?
    var roundTime: String?
    var startDate: Double?
    var endDate: Double?
    var tournamentStatus: String?
    var entryType: Int?
    var entryFees: Int64?
    var description: String?
    var venue: String?
    var usersImages: [[String : AnyObject]]?
    var registeredPlayers: Int?
    var duration: Int?
    var isCheckIn: Int?
    var isRegister: Int?
    var ratingStatus: Int?
    var checkInStatus: Int?
    var winnerPlayerName: String?
    var winnerUserId: Int64?
    var winnerPlayerImage: String?
    var winnerPlayerRating: Int?
    var winnerPlayerSOS: Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        image <- map["image"]
        tournamentType <- map["tournamentType"]
        title <- map["title"]
        roundTime <- map["roundTime"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
        tournamentStatus <- map["tournamentStatus"]
        entryType <- map["entryType"]
        entryFees <- map["entryFees"]
        description <- map["description"]
        venue <- map["venue"]
        usersImages <- map["usersImages"]
        registeredPlayers <- map["registeredPlayers"]
        duration <- map["duration"]
        isCheckIn <- map["isCheckin"]
        isRegister <- map["isRegister"]
        ratingStatus <- map["ratingStatus"]
        checkInStatus <- map["checkInStatus"]
        winnerPlayerName <- map["tournamentWinner.full_name"]
        winnerPlayerImage <- map["tournamentWinner.image"]
        winnerPlayerRating <- map["tournamentWinner.rating"]
        winnerPlayerSOS <- map["tournamentWinner.sos"]
        winnerUserId <- map["tournamentWinner.id"]
    }
    
}

/*
    Use:- Model used for store tournament of three section in home screen
    Screen:- TournamentViewController
*/
struct TournamentModel : Mappable {
  
    var openRegistration : [TournamentDetailModel]?
    var currentlyRunning : [TournamentDetailModel]?
    var myTournament : [TournamentDetailModel]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        openRegistration <- map["openForRegistration"]
        currentlyRunning <- map["currentlyRunning"]
        myTournament <- map["myTournament"]
    }
}

/*
    Use:- Model used for store all tournament list
    Screen:- TournamentSearchViewController
*/
struct TournamentListModel: Mappable {
   
    var data : [TournamentDetailModel]? = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        data <- map[CJsonData]
    }
}

/*
    Use:- Model used for store tournament All User
    Screen:- TournamentUserViewController
*/
struct TournamentAllUserDetailModel: Mappable {

    var id: Int64?
    var fullName: String?
    var image: String?
    var sos: Int?
    var rating: Int?
   
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        fullName <- map["fullName"]
        image <- map["image"]
        sos <- map["sos"]
        rating <- map["rating"]
    }
}

struct TournamentAllUserModel : Mappable {
    
    var data: [TournamentAllUserDetailModel]? = []
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        data <- map[CJsonData]
    }
}



