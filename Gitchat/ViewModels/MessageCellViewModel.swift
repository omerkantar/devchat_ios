//
//  MessageCellViewModel.swift
//  Gitchat
//
//  Created by omer on 23.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class MessageCellViewModel {

    var username: String?
    var message: String?
    var time: String?
    var isGroup: Bool = false
    var isCurrent: Bool = false
    var photoURL: URL?
    var hasUrl = false
    
    var model: Message?
    
    init(message: Message) {
        self.model = message
        self.message = message.text
        
        if let name = message.author?.username {
            self.username = name 
            if name == User.current.username {
                self.isCurrent = true
            }else {
                self.isCurrent = false
            }
        }
        
        if let url = message.getPhotoURL() {
            self.hasUrl = true
            self.photoURL = url
            
        }
        
        self.time = ""
        
        if let time = message.getTime() {
            self.time = time
        }
        
    }
    
    

    
}
