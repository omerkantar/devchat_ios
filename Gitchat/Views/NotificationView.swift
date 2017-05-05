//
//  NotificationView.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var circleView: UIView!

    var tapGR: UITapGestureRecognizer?
    
    var notification: Notification?

    var tappedBlock: ((_ state: Bool) -> ())?
    
    class func show(title: String, tappedBlock: ((_ state: Bool) -> ())?) {
        let view = Bundle.main.loadNibNamed(String(describing: NotificationView.self), owner: nil, options: nil)?.first as! NotificationView

        view.design()
        view.show()
        var tapped = false
        view.tappedBlock  = { (state) in
            tapped = true
            view.removeFromSuperview()
            if let block = tappedBlock {
                block(true)
            }
        }
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { (tmr) in
                
                if (tapped == false) {
                    view.removeFromSuperview()
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    class func show(withNotification notification: Notification, tappedBlock: ((_ state: Bool) -> ())?) {
        
        let view = Bundle.main.loadNibNamed(String(describing: NotificationView.self), owner: nil, options: nil)?.first as! NotificationView
        view.notification = notification
        view.design()
        view.show()
        var tapped = false
        view.tappedBlock  = { (state) in
            tapped = true
            view.removeFromSuperview()
            if let block = tappedBlock {
                block(true)
            }
        }
       
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { (tmr) in
                
                if (tapped == false) {
                    view.removeFromSuperview()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    
    }
    
    func design() {
        self.circleView.backgroundColor = UIColor.clear
        self.circleView.layer.cornerRadius = self.circleView.layer.bounds.height / 2.0
        self.circleView.layer.borderWidth = 3.0
        self.circleView.layer.borderColor = UIColor.white.cgColor
        
        
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        
        if let notification = notification {
            self.titleLabel.text = notification.getNotificationMessage()

        }
    }
    
    func show() {
        let screenSize = UIScreen.main.bounds.size
        var origin = CGPoint.zero
        origin.x = (screenSize.width - 300) / 2.0
        origin.y = screenSize.height - 80.0 - 50.0
        let size = self.frame.size
        self.frame = CGRect(origin: origin, size: size)
        UIApplication.shared.keyWindow?.addSubview(self)
        
    }
    
    
    @IBAction func tappedButton() {
        if let block = tappedBlock {
            block(true)
        }
    }
    
    
}
