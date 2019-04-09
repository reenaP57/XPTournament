//
//  CMS.swift
//  Netrealty
//
//  Created by mac-0005 on 17/01/19.
//  Copyright © 2019 mac-0005. All rights reserved.
//

import Foundation
import ObjectMapper

/*
    Use:- Model used for store CMS data
    Screen:- CMSViewController
*/
struct CMSModel : Mappable {

    var id:Int?
    var title:String?
    var seoUrl:String?
    var description:String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        seoUrl <- map["seoUrl"]
        description <- map["description"]
    }
    
}
