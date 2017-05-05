
//
//  Conversation.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Tailor

class Conversation: Mappable, RequestModelDataSource {
    
    var id: String?
    var name: String?
    var description: String?
    var photoUrl: String?
    var members: [User]?
    var admins: [User]?
    var messages: [Message]?
    var inventationUsers: [User]?
    var rejectUsers: [User]?
    var createAt: String?
    var membersUsername: [String]?
    
    var photo: UIImage? // only group save
    
    var isGroup: Bool {
        get {
            if let members = members {
                if members.count > 2 {
                    return true
                }
                return false
            }
            return false
        }
    }
    
    init() {
        
    }
    
    required init(_ map: [String : Any]) {
        id <- map.property("_id")
        name <- map.property("name")
        description <- map.property("description")
        photoUrl <- map.property("photo_url")
        members <- map.relations("members")
        admins <- map.relations("admins")
        messages <- map.relations("messages")
        inventationUsers <- map.relations("invitation_users")
        rejectUsers <- map.relations("reject_users")
        createAt <- map.property("create_at")
        
    }
    
    func params() -> [String : AnyObject]? {
        
        var data = [String: AnyObject]()
        
        if let members = membersUsername {
            data["members"] = members as AnyObject
        }
        
        if let name = name {
            data["name"] = name as AnyObject
        }
        
        
        if let description = description {
            data["description"] = description as AnyObject
        }
        
        if let photoUrl = photoUrl {
            data["photo_url"] = photoUrl as AnyObject
        }
        
        
        
        return data
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




