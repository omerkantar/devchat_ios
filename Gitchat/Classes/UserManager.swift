//
//  UserManager.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class UserManager: NSObject {

    static let USER_KEY_PATH = "USER_KEY_PATH"
    
    
    class func hasUser() -> Bool {
        if let username = getUserName() {
            if username != "" {
                    return true
            }
        }
        return false
    }
    
    class func buildCurrentUser(_ success: @escaping (() -> Void), failure: @escaping ((_ error: APIError?) -> Void)) {
        
        if let username = getUserName() {
            User.current.username = username
            UserService.getUser(username, success: { (user) in
                User.current = user
                success()
            }, failure: failure)
        }
        
    }
    
    class func getUserName() -> String? {
        let defaults = UserDefaults.standard
        if let name = defaults.value(forKey: USER_KEY_PATH) as? String {
            return name
        }
        return nil
    }
    
    
    class func logout() {
        saveUsername(username: nil)
    }
    
    class func saveUsername(username: String?) {
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: USER_KEY_PATH)
        defaults.synchronize()
    }
    
    
}
