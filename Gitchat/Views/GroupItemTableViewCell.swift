//
//  GroupItemTableViewCell.swift
//  Gitchat
//
//  Created by omer on 27.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class GroupItemTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var groupImgContainerView: UIView!
    @IBOutlet weak var groupImgView: UIImageView!
    
    @IBOutlet weak var firstImgContainerView: UIView!
    @IBOutlet weak var secondImgContainerView: UIView!
    @IBOutlet weak var thirdImgContainerView: UIView!
    
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var secondImgView: UIImageView!
    @IBOutlet weak var thirdImgView: UIImageView!
    
    var model: Conversation? {
        didSet {
            if let model = model,
                let nameLabel = nameLabel,
                let descriptionLabel = descriptionLabel,
                let firstImgContainerView = firstImgContainerView,
                let secondImgContainerView = secondImgContainerView,
                let thirdImgContainerView = thirdImgContainerView,
                let firstImgView = firstImgView,
                let secondImgView = secondImgView,
                let thirdImgView = thirdImgView,
                let groupImgContainerView = groupImgContainerView,
                let groupImgView = groupImgView {
                
                groupImgView.image = nil
                firstImgView.image = nil
                secondImgView.image = nil
                thirdImgView.image = nil
                
                
                nameLabel.text = model.name
                descriptionLabel.text = model.description
                
                
                addShadow(v: groupImgContainerView, opacity: 0.75, radius: 5.0)
   
                groupImgView.layer.cornerRadius = 5.0
                groupImgView.clipsToBounds = true
                
                design(imgView: firstImgView)
                design(imgView: secondImgView)
                design(imgView: thirdImgView)
                
                if let url = model.getPhotoURL() {
                    groupImgView.af_setImage(withURL: url)
                }
                
                if let members = model.members {
                    
                    let first = members[0]
                    let second = members[1]
                    let third = members[2]
                    
                    buildImg(user: first, imgView: firstImgView)
                    buildImg(user: second, imgView: secondImgView)
                    buildImg(user: third, imgView: thirdImgView)
                    
                    
                    
                }
                
                
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func design(imgView: UIImageView) {
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        imgView.layer.cornerRadius = imgView.layer.bounds.size.height / 2.0
        imgView.layer.borderWidth = 2.0
        imgView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
    }
    
    func addShadow(v: UIView, opacity: Float, radius: CGFloat) {
        v.layer.shadowColor = UIColor.darkGray.cgColor
        v.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        v.layer.shadowOpacity = opacity
        v.layer.shadowRadius = radius
        v.backgroundColor = UIColor.clear
        v.clipsToBounds = false
    }
    
    
    func buildImg(user: User, imgView: UIImageView) {
        if let url = user.getPhotoURL() {
            imgView.af_setImage(withURL: url)
        }
        
        imgView.layer.borderColor = user.getStatusColor().cgColor
        
    }
    
    
}
