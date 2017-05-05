//
//  AppDelegate.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
        window?.backgroundColor = UIColor.black
        window?.layer.masksToBounds = true
        window?.layer.cornerRadius = 3.0
                
        let nc = NavigationViewController(rootViewController: EntranceViewController())
        
        ImagePathNameManager.removeAllImages()

        
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketService.manager.emitStatus(status: "bussy")
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketService.manager.emitStatus(status: "online")
        
    }
    
//    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
//        GitHubAPIManager.sharedInstance.processOauthStep1Response(url: url)
//        return true
//    }

}

