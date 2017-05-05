//
//  GroupTableViewCell.swift
//  Gitchat
//
//  Created by omer on 23.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imgContainerView: UIView!
    
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!
    @IBOutlet weak var thirdImgView: UIImageView!
    
    var model: Conversation? {
        didSet {
            if let model = model,
                let nameLabel = nameLabel,
                let descLabel = descriptionLabel,
                let firstImgView = firstImgView,
                let secondImgView = secondImgView,
                let thirdImgView = thirdImgView {
                
                nameLabel.text = model.name
                descLabel.text = model.description
                
                self.design(imgView: firstImgView)
                self.design(imgView: secondImgView)
                self.design(imgView: thirdImgView)
                
                if let members = model.members {
                    if members.count >= 3 {
                        var first = members.first
                        var second = members[1]
                        var third = members[2]
                        
                        if let url = first?.getPhotoURL() {
                            firstImgView.af_setImage(withURL: url)
                            firstImgView.layer.borderColor = first?.getStatusColor().cgColor
                        }
                        
                        if let url = second.getPhotoURL() {
                            secondImgView.af_setImage(withURL: url)
                            secondImgView.layer.borderColor = second.getStatusColor().cgColor
                        }
                        
                        if let url = third.getPhotoURL() {
                            thirdImgView.af_setImage(withURL: url)
                            thirdImgView.layer.borderColor = third.getStatusColor().cgColor
                            
                        }
                    }
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func design(imgView: UIImageView) {
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        imgView.layer.cornerRadius = imgView.layer.bounds.size.height / 2.0
        imgView.layer.borderWidth = 2.0
        imgView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
    }
}
