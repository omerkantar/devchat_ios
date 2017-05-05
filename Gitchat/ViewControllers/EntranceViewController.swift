//
//  EntranceViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class EntranceViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            UIView.animate(withDuration: 1.0, animations: {
                self.view.backgroundColor = UIColor.white
            }, completion: { (fns) in
                self.navigate()
            })
            
        }
    }
    
    func navigate() {
        
        
        if UserManager.hasUser() {
            
            addLoadingView(withView: self.view, title: "Yükleniyor")

            UserManager.buildCurrentUser({
                
                self.removeLoadingView()
                
                let tabVC = TabViewController()
                self.navigationController?.viewControllers = [tabVC]

            }, failure: { (error) in
                self.removeLoadingView()

                self.logout()
            })
            
        }else {
            let onBoardingVC = OnboardingViewController()
            self.navigationController?.viewControllers = [onBoardingVC]

        }
        
    }
    

}
