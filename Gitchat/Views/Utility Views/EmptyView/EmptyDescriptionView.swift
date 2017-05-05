//
//  EmptyInformationView.swift
//  Bulbasaur
//
//  Created by omer on 11.01.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class EmptyDescriptionView: UIView {

    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var tappedDescriptionViewBlock: (() -> ())?
    
    
    class func create(withDescription description: String, tappedDescriptionViewBlock: ((_ view: EmptyDescriptionView) -> ())? = nil) -> EmptyDescriptionView {
        
        
        let nibName = String(describing: EmptyDescriptionView.self)
        let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! EmptyDescriptionView
        
        view.descriptionLabel.text = description
        
        view.build()        
        
        return view
        
    }

    
    func build() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedDescriptionTapGR))
        
        containerView.addGestureRecognizer(tapGR)
        
//        GenericUtility.addShadow(toView: containerView, offset: CGSize.zero, radius: 4.0, opacity: 0.2, color: UIColor.darkGray)
        
    }
    
    
    
    
    // MARK: - TapGR Delegate
    
    func tappedDescriptionTapGR(tapGR: UITapGestureRecognizer) {
        
        if let block = tappedDescriptionViewBlock {
            block()
        }
    }

}
