//
//  UserModel.swift
//  InhaChatBot
//
//  Created by 안종표 on 2021/05/08.
//

import UIKit
import ObjectMapper

struct UserModel: Mappable{
    
    var uid : String?
    var StudentID : String?
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        uid <- map["uid"]
//        pushToken <- map["pushToken"]
        StudentID <- map["StudentID"]
    }
}
