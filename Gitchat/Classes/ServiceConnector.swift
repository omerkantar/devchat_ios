//
//  ServiceConnector.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Alamofire


let BASE_CHAT_API_URL = "http://139.59.132.139:3000/"

class ServiceConnector {
    
    class func getURLString(url: String) -> String {
        return BASE_CHAT_API_URL + url
    }
    
    class func request(options: RequestOptions, success: ((_ response: APIResponse)-> ())? = nil, failure: ((_ error: APIError) -> ())? = nil) {
        
        let url = getURLString(url: options.url!)
        
        Alamofire.request(url, method: options.type.AlamofireType, parameters: options.body, encoding: JSONEncoding.default, headers: options.headers).validate { request, response, data in
            // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
            return .success
            }
            .responseJSON { response in
                
                print(response.result)   // result of response serialization
                
                
                switch (response.result) {
                case .success(let JSON):
                    
                    print(JSON)
                    
                    if JSON is [String: AnyObject] {
                        
                        let response = APIError(JSON as! [String : Any])
                        
                        if response.dbError != nil {
                            if let block = failure {
                                block(response)
                            }
                        }else {
                            if let block = success {
                                block(response)
                            }
                        }
                        
                    }
                    
                    
                    break
                case .failure(let error):
                    
                    if let block = failure {
                        let err = APIError()
                        err.alamofireError = error
                        block(err)
                    }
                    
                    break
                }
        }
        
    }
}
