//
//  Notification.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

enum NotificationType {
    case message, status, success
}

class Notification {
    
    var type: NotificationType = .message
    var status: NotificationType = .status
    var user: User?
    var conversation: Conversation?
    var message: Message?
    
    func getNotificationMessage() -> String {
        
        switch self.type {
        case .message:
            var text = "Mesaj geldi: "
            if let conversation = conversation,
                let name = conversation.name {
                text +=  name + " gruptan mesaj geldi! "
            }
            
            if let name = message?.author?.username,
                let msg = message?.text {
                text += name + " : " + msg
            }
            
            text += " detay için tıkla!"
            
            return text
        case .status:
            var text = ""
            if let user = user,
                let username = user.username {
                
                if user.status == "online" {
                    text += username + " " + " giriş yaptı. Hadi hoş geldin demek için tıkla!"
                }
                
            }
            
            return text
            
        case .success:
            
            var msg = "Başarılı bir şekilde "
            if let con = conversation {
                if let name = con.name {
                    msg +=  name + " group oluşturuldu."
                }else {
                    msg += "chat oluşturuldu."
                }
            }
            return msg
        }
        
    }
}
