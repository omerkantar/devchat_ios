//
//  APIResponse.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Tailor

class APIResponse: Mappable {

    var data: AnyObject?
    var meta: APIMeta?
    
    init() {
    
    }
    
    required init(_ map: [String : Any]) {
        data <- map.property("data")
        meta <- map.relation("meta")
    }
    
}


class APIError: APIResponse {
    
    var alamofireError: Error?
    var message: String?
    var dbError: AnyObject?
   
    override init() {
        super.init()
    }
    
    required init(_ map: [String : Any]) {
        super.init(map)
        message <- map.property("data.message")
        dbError <- map.property("data.db_error")
        
    }
    
}

class APIMeta: Mappable {
    
    var isSuccess: Bool = false
    var isArray: Bool = false
    var status: Int = -1
    
    required init(_ map: [String : Any]) {
        isSuccess <- map.property("is_success")
        isArray <- map.property("is_array")
        status <- map.property("status")
    }
}
