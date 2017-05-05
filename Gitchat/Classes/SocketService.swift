//
//  SocketService.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import SocketIO
import Tailor
import SwiftyJSON

enum SocketOnType {
    case status, message
}

protocol SocketDelegate {
    func socket(socket: SocketService, onType: SocketOnType)
    
}

class SocketService {

    static var manager = SocketService()
    
    var socket: SocketIOClient?
    
    var delegate: SocketDelegate?
    
    
    func connect() {
        
        let url = BASE_CHAT_API_URL
        
        socket = SocketIOClient(socketURL: URL(string: url)!, config: [.log(true), .forcePolling(true), .forceNew(true), .forceWebsockets(true)])
        
        
        socket?.on("connect") { data, act in
            print("socket connected data", data, act)
            
        }
        
        
        socket?.onAny({ [weak self] (event) in
            
            let data = event.event
            if data != "" {
                self?.handle(event: data)
            }
        })
        
        socket?.connect()
        
        
        
        
        
    }
    
    
    func emitStatus(status: String) {
        
        if let username = UserManager.getUserName() {
            let data = ["username": username,
                               "status": status]
            
            if let socket = socket {
                socket.emit("status", with: [data] as [Any])
            }

        }
    }
    
    func emitMessage(message: Message) {
        if let _ = UserManager.getUserName() {

            if let params = message.params() {
                
                socket?.emit("message", params)
                socket?.connect()
            }
            
        }
    }
    
    
    func handle(event: String) {
        
        if event == "error" ||
            event == "connect" ||
            event == "reconnect" {
            return
        }
        
        let rangeMessage = event.range(of: "message")
        let rangeStatus = event.range(of: "status")
        
        
        if rangeStatus != nil && rangeMessage != nil {
            if let delegate = delegate {
                var type = SocketOnType.status
                if rangeMessage != nil {
                    type = .message
                }
                delegate.socket(socket: self, onType: type)
            }
            
        }
    }
    

    
}

