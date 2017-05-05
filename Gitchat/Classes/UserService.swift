//
//  UserService.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit



class UserService: ServiceConnector {
    
    class func getUser(_ username: String, success: @escaping ((_ user: User) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
        
        var url = "users/detail"
        if username == UserManager.getUserName() {
           url = "users/me"
        }
        url += "?username=" + username
        
        let options = RequestOptions(url, type: .get)
        
        request(options: options, success: { (res) in
            
            if let data = res.data as? [String: Any] {
                let user = User(data)
                success(user)
            }else {
                failure(nil)
            }
            
        }) { (error) in
            failure(error)
        }
        
    }
    
    class func registerUser(_ user: User, success: @escaping ((_ user: User) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
        
        let body = ["user": user.params()]

        let options = RequestOptions("users/register", type: .post, headers: nil, body: body as [String : AnyObject])
        
        request(options: options, success: { (res) in
            
            if let data = res.data as? [String: Any] {
                let user = User(data)
                success(user)
            }else {
                failure(nil)
            }
            
        }) { (error) in
            failure(error)
        }
        
    }
    
    class func login(_ user: User, success: @escaping ((_ users: User) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
        
        let body = ["user": user.params()]
        let options = RequestOptions("users/login", type: .post, headers: nil, body: body as [String : AnyObject])
        
        request(options: options, success: { (res) in
            
            if let data = res.data as? [String: Any] {
                let user = User(data)
                success(user)
            }else {
                failure(nil)
            }
            
        }) { (error) in
            failure(error)
        }
        
        
    }
    
    class func allUsers(_ success: @escaping ((_ users: [User]) -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
        
        let options = RequestOptions("users/all", type: .get)
        
        request(options: options, success: { (res) in
            
            if let data = res.data as? [[String: Any]] {
                var list = [User]()

                data.forEach({ (obj) in
                    list.append(User(obj))
                })
                
                success(list)
                
            }else {
                failure(nil)
            }
            
        }, failure: failure)
    }
    
    
    class func logout(completion: @escaping (() -> ())) {
        let options = RequestOptions("users/logout", type: .post, body: ["username": User.current.username! as AnyObject])
        
        request(options: options, success: { (res) in
            completion()

        }) { (err) in
            completion()

        }
    }
    
    
}
