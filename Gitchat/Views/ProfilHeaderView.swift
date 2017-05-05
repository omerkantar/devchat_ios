//
//  ProfilHeaderView.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfilHeaderView: UIView {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
 
    var model: User? {
        didSet{
            if let model = model,
                let imageView = imageView,
                let usernameLabel = usernameLabel,
                let nameLabel = nameLabel,
                let statusView = statusView {
                
                usernameLabel.text = model.getUsernameWithHash()
                nameLabel.text = model.name
                
                statusView.backgroundColor = UIColor.green
                statusView.layer.cornerRadius = statusView.layer.bounds.height / 2.0
                
                imageView.layer.cornerRadius = imageView.layer.bounds.height / 2.0
                imageView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
                imageView.layer.borderWidth = 3.0
                imageView.clipsToBounds = true
                
                if let photoUrl = model.getPhotoURL() {
                    imageView.af_setImage(withURL: photoUrl)
                }
                
            }
        }
    }
    
    class func create() -> ProfilHeaderView {
        let nibName = String(describing: ProfilHeaderView.self)
        let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! ProfilHeaderView
        view.model = User.current
        return view
    }
    
}
