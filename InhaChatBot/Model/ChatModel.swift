//
//  ChatModel.swift
//  InhaChatBot
//
//  Created by 안종표 on 2021/05/08.
//

import ObjectMapper
struct ChatModel: Mappable {
    
    public var users :Dictionary<String,Bool> = [:] //채팅방에 참여한 사람들
    public var comments :Dictionary<String,Comment> = [:] //채팅방의 대화내용
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    
    struct Comment :Mappable{
        public var uid : String?
        public var message : String?
        public var timestamp :Int?
        init?(map: Map) {}
        
        mutating func mapping(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
            timestamp <- map["timestamp"]
        }
    }
}
