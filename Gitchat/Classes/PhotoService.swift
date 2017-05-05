//
//  PhotoService.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import Alamofire

enum PhotoUploadType: String {
    
    case profil = "profil", message = "message"
    
    var urlString: String {
        switch self {
        case .profil:
            return "users/photo"
        case .message:
            return "conversations/photo"
        }
    }
}

class PhotoService: ServiceConnector {


    class func getAll() {
        
    }
    
    class func upload(image: UIImage, type: PhotoUploadType, completion: @escaping ((_ isSuccess: Bool, _ photo: Photo?)-> Void)) {
        
        
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            
            do {
                let pathName = ImagePathNameManager.getNewImagePathName()
                let documentsUrl =  ImagePathNameManager.getDocumentsDirectory().appendingPathComponent(pathName)
                
                    try?  data.write(to: documentsUrl)
                
            } catch {
                completion(false, nil)
                return
            }

            let url = self.getURLString(url: "users/photo")
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(data, withName: "image", fileName: "photo.jpeg", mimeType: "image/jpeg")
                
                
                }, to: url, method: .post,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON(completionHandler: { (json) in
                                
                                switch json.result {
                                case .success(let JSON):
                                    
                                    let api = APIResponse(JSON as! [String: Any])
                                    print("JSON :", JSON)
                                    
                                    if let data = api.data as? [String: Any] {
                                        
                                        let photo = Photo(data)
                                        completion(true, photo)
                                    
                                    }
                                    break
                                    
                                case .failure(let error):
                                    completion(false, nil)
                                    break
                                    
                                }
                                
                            })
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                            completion(false, nil)
                        }
            })
        }
    }
    
 
}

