//
//  Photo.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Tailor

class Photo: Mappable {
    
    var id: String?
    var photoUrl: String?
    var type: String?
    
    required init(_ map: [String : Any]) {
        id <- map.property("_id")
        photoUrl <- map.property("photo_url")
        type <- map.property("type")
    }
    
}
