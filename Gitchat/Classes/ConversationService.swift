//
//  ConversationService.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class ConversationService: ServiceConnector {

    
    class func getDetail(con: Conversation, success: @escaping ((_ conversation: Conversation) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
        
        var url = "conversations/detail"
        
        if let id = con.id {
            url += "?conversation_id=" + id
        }
        
        let options = RequestOptions(url, type: .get)

        request(options: options, success: { (res) in
            
            if let data = res.data as? [String: Any] {
                let conversation = Conversation(data)
                success(conversation)
            }else {
                failure(nil)
            }
            
        }) { (err) in
            failure(err)
        }
        
        
    }
    
    
    class func getChats(success: @escaping ((_ list: [Conversation]) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {

        var url = "conversations/chats"
        

        if let username = UserManager.getUserName() {
            url += "?username=" + username
        }
        
        let options = RequestOptions(url, type: .get)
        
        request(options: options, success: { (res) in
            
            if let data = res.data as? [[String: Any]] {
                var list = [Conversation]()
                
                for obj in data {
                    let con = Conversation(obj)
                    list.append(con)
                }
                success(list)
            }else {
                failure(nil)
            }
            
        }) { (error) in
            failure(error)
        }
    }
    
    class func getGroups(success: @escaping ((_ list: [Conversation]) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
     
        
        let url = "conversations/groups"
        
        let options = RequestOptions(url, type: .get)
        
        request(options: options, success: { (res) in
            
            if let data = res.data as? [[String: Any]] {
                var list = [Conversation]()
                
                for obj in data {
                    let con = Conversation(obj)
                    list.append(con)
                }
                success(list)
            }else {
                failure(nil)
            }
            
        }) { (error) in
            failure(error)
        }

    }
    
    
    class func save(con: Conversation, success: @escaping ((_ conversation: Conversation) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
        
        let url = "conversations/new"

        let options = RequestOptions(url, type: .post)
        
        if let username = User.current.username {
            options.body = ["username": username as AnyObject,
                            "conversation": con.params() as AnyObject]
        }
        
        request(options: options, success: { (res) in
            
            if let data = res.data as? [String: Any] {
                let conversation = Conversation(data)
                success(conversation)
            }else {
                failure(nil)
            }
            
        }) { (err) in
            failure(err)
        }
        
        
    }
}
