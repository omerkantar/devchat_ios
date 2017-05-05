//
//  ProfilImageHeaderView.swift
//  Gitchat
//
//  Created by omer on 27.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfilImageHeaderView: UIView {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    
    var model: User? {
        didSet {
            if  let model = model,
                let usernameLabel = usernameLabel,
                let nameLabel = nameLabel,
                let descriptionLabel = descriptionLabel,
                let imgView = imgView {
                
                if let url = model.getPhotoURL() {
                    imgView.af_setImage(withURL: url)
                }
                
                usernameLabel.text = model.username
                nameLabel.text = model.name
                descriptionLabel.text = model.description
            }
        }
    }
    
    class func create(user: User) -> ProfilImageHeaderView {
        
        let nibName = String(describing: ProfilImageHeaderView.self)
        let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! ProfilImageHeaderView
        view.design()
        view.model = user
        return view
    }
    
    
    
    func design() {
        
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10.0
        
        addShadow(v: imgContainerView, opacity: 0.75, radius: 5.0)
        
        
    }
    
    
    
    
    func addShadow(v: UIView, opacity: Float, radius: CGFloat) {
        v.layer.shadowColor = UIColor.darkGray.cgColor
        v.layer.shadowOffset = CGSize.zero
        v.layer.shadowOpacity = opacity
        v.layer.shadowRadius = radius
        v.backgroundColor = UIColor.clear
        v.clipsToBounds = false
    }
    
    
    func dashedBorderLayerWithColor(color:CGColor, view: UIView) {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = view.frame.size
        
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 1)
        
        borderLayer.bounds = shapeRect
        
        borderLayer.position = CGPoint.zero
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth = 1
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 16),NSNumber(value:4)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.cgPath
        
        view.layer.addSublayer(borderLayer)
        
    }
    
}
