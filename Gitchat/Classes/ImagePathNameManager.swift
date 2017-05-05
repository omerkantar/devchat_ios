//
//  ImagePathNameManager.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class ImagePathNameManager {
    
    static let IMG_PATH_NAME = "IMG_PATH_NAME_ARRAY"
    
    class func getNewImagePathName() -> String {
        return String(Date().timeIntervalSince1970) + ".jpeg"

    }
    
    class func getImagePathNames() -> [String]? {
        let userDefaults = UserDefaults.standard
        let list = userDefaults.stringArray(forKey: IMG_PATH_NAME)
        return list
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func removeAllImages() -> Bool {
        
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    
                    if (fileName.hasSuffix(".jpeg"))
                    {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }else if (fileName.hasSuffix(".png")) {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
            }
            return true
            
        } catch {
            print("Could not clear temp folder: \(error)")
            return false
        }
        
        return true
    }
    
    
    class func savePathName(pathName: String) {
        let userDefaults = UserDefaults.standard
        var list = userDefaults.stringArray(forKey: IMG_PATH_NAME)
        list?.append(pathName)
        userDefaults.set(list, forKey: IMG_PATH_NAME)
        userDefaults.synchronize()
    }
    
    
    class func deleteAllPathName() {
        let _ = removeAllImages()
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: IMG_PATH_NAME)
        defaults.synchronize()
    }
   
    
}
