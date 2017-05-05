//
//  LoadingView.swift
//  Bulbasaur
//
//  Created by omer on 11.01.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    class func create(title: String? = nil) -> LoadingView {
        
        let nibName = String(describing: LoadingView.self)
        let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! LoadingView

        var text = "Loading"
        if let title = title {
            text = title
        }
        view.progressLabel.text = text
        view.activityIndicatorView.hidesWhenStopped = true
        view.frame = CGRect.zero
        
        return view
    }
    
    func startAnimating() {
        
        // Loading waiting 300ms for ux
        let delayTime = DispatchTime.now() + Double(Int64(0.23 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
            //starting
            self.activityIndicatorView.startAnimating()

        }

    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
    
}
