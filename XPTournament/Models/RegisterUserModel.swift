//
//  RegisterUserModel.swift
//  XPTournament
//
//  Created by mac-00011 on 22/03/19.
//  Copyright © 2019 mac-00017. All rights reserved.
//

import Foundation
import ObjectMapper

struct RegisterUserModel: Mappable {
    
    var isCheckIn: Int?
    var checkInStatus: Int?
    var status: Int?
    var message: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        isCheckIn <- map["meta.isCheckIn"]
        checkInStatus <- map["meta.checkInStatus"]
        status <- map["meta.status"]
        message <- map["meta.message"]
    }
    
    
}
