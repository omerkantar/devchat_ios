//
//  RequestOptions.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Alamofire

enum RequestType {
    case get, post, put, delete
    
    var AlamofireType: HTTPMethod {
        switch self {
        case .get:
            return HTTPMethod.get
        case .post:
            return HTTPMethod.post
        case .put:
            return HTTPMethod.put
        case .delete:
            return HTTPMethod.delete
        }
    }
}

class RequestOptions {
    var url: String?
    var type: RequestType = .get
    var headers: [String: String]?
    var body: [String: AnyObject]? // Params
    
    init(_ url: String, type: RequestType, headers: [String: String]? = nil, body: [String: AnyObject]? = nil) {
        
        self.url = url
        self.type = type
        self.headers = headers
        self.body = body
    }
}


protocol RequestModelDataSource {
    func params() -> [String: AnyObject]?
}
