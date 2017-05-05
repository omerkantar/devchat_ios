//
//  User.swift
//  Gitchat
//
//  Created by omer on 23.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Tailor

class User: Mappable, RequestModelDataSource {

    static var current = User()
    var id: String? = ""
    var name: String? = ""
    var username: String? = ""
    var email: String? = ""
    var password: String? = ""
    var description: String? = ""
    var photoUrl: String? = ""
    var status: String? = ""
    
    var conversations: [Conversation]?
    var conversationCount: Int = 0
    
    init() {
        
    }
    
    required init(_ map: [String : Any]) {
        id <- map.property("_id")
        name <- map.property("name")
        username <- map.property("username")
        email <- map.property("email")
        description <- map.property("description")
        photoUrl <- map.property("photo_url")
        status <- map.property("status")
        conversations <- map.relations("conversations")
        conversationCount <- map.property("conversation_count")
        
    }
    
    
    // MARK : - RequestModelDataSource
    func params() -> [String : AnyObject]? {

        if let name = name,
            let username = username,
            let email = email,
            let password = password,
            let description = description,
            let photoUrl = photoUrl {
            
            let data = ["name": name,
                        "username": username,
                        "email": email,
                        "password": password,
                        "description": description,
                        "photo_url": photoUrl]
            return data as [String : AnyObject]
        }
        
        return nil
    }
    
    
    func getStatusColor() -> UIColor {
        
        let online = "online"
        let offline = "offline"
        
        if let status = status {
            switch status {
            case online:
                return UIColor.green
            case offline:
                return UIColor.red
            default:
                return UIColor.yellow
            }
        }
        return UIColor.red
    }
    
    func getUsernameWithHash() -> String {
        if let username = username {
            return "@" + username
        }
        return "unknow"
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
}
