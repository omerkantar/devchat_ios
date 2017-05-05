//
//  SelectItemTableViewCell.swift
//  Gitchat
//
//  Created by omer on 26.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class SelectItemTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    var model: SelectItem? {
        didSet {
            if let model = model,
                let user = model.model,
                let nameLabel = nameLabel,
                let usernameLabel = usernameLabel,
                let imgContainerView = imgContainerView,
                let imgView = imgView {
                
                nameLabel.text = user.name
                usernameLabel.text = user.username
                imgView.image = nil
                imgView.layer.cornerRadius = imgView.layer.bounds.size.height / 2.0
                
                if let url = user.getPhotoURL() {
                    imgView.af_setImage(withURL: url)
                
                }
                
                imgContainerView.layer.cornerRadius = 25.0
                imgContainerView.layer.borderWidth = 2.0
                imgContainerView.layer.borderColor = user.getStatusColor().cgColor
                
                
                if model.isSelected {
                    nameLabel.textColor = UIColor.blue
                    self.accessoryType = .checkmark
                }else {
                    nameLabel.textColor = UIColor.black
                    self.accessoryType = .none
                }
            }
        }
    }
    
}
