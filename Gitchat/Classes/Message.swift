//
//  Message.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Tailor

class Message: Mappable, RequestModelDataSource {
    
    var id: String?
    var author: User?
    var text: String?
    var readUsers: [User]?
    var createAt: String?
    var conversationId: String?
    var photoUrl: String?
    
    var conversation: Conversation?
    
    init() {
        
    }
    
    required init(_ map: [String : Any]) {
        id <- map.property("_id")
        author <- map.relation("author")
        text <- map.property("text")
        readUsers <- map.relations("read_users")
        createAt <- map.property("create_at")
        photoUrl <- map.property("photo_url")
        conversationId <- map.property("conversation_id")
        
    }
    
    
    func params() -> [String : AnyObject]? {
        
        if let conId = conversationId,
            let name = User.current.username {
            
            var data = ["username": name,
                        "conversation_id": conId]
            
            if let text = text {
                data["message"] = text
            }
            
            if let photoUrl = photoUrl {
                data["photo_url"] = photoUrl
            }
            
            return data as [String: AnyObject]
        }
        
        return nil
    }
    
    func getPhotoURL() -> URL? {
        if let photoUrl = photoUrl {
            var all = photoUrl
            if photoUrl.hasPrefix("http") == false {
                all = "http://" + photoUrl
            }
            
            
            if let url = URL(string: all) {
                return url
            }
        }
        
        return nil
    }
    
    func getTime() -> String? {
        if let createAt = createAt {
            
            let formatter = DateFormatter()
            //"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "HH:mm"
            
            
            if let date = formatter.date(from: createAt) {
                let str = formatter2.string(from: date)
                return str
            }
            
        }
    
        return nil
    }
    
}


class MessageResponse: Mappable {
    var message: Message?
    var conversationId: String?
    var authorName: String?
    
    required init(_ map: [String : Any]) {
        message <- map.relation("message")
        conversationId <- map.property("conversation_id")
        authorName <- map.property("author_name")
        
    }
}
