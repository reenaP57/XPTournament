//
//  UserModel.swift
//  XPTournament
//
//  Created by mac-0005 on 16/01/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

/*
    Use:- Model used for store User detail
    Screen:- LRF Screen
*/
struct UserDetailModel : Mappable {
    
    var fullName:String?
    var email:String?
    var userName:String?
    var mobileNo:String?
    var isNotify:Bool?
    var image:String?
    var id:Int64?
    var qrCode:String?
    var totalTournament:Int64?
    var avgRating:Double?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        fullName <- map["fullName"]
        email <- map["email"]
        userName <- map["userName"]
        mobileNo <- map["mobileNo"]
        isNotify <- map["isNotify"]
        image <- map["image"]
        qrCode <- map["qrCode"]
        totalTournament <- map["totalTournament"]
        avgRating <- map["avgRating"]
    }
    
}

struct UserMetaModel : Mappable {
    
    var token:String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        token <- map["token"]
    }
}

struct UserModel : Mappable {
    
    var data: UserDetailModel?
    var meta: UserMetaModel?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        meta <- map["meta"]
    }
}
