//
//  UserTableViewCell.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class UserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var model: User? {
        didSet {
            if let user = model,
                let imageView = imgView,
                let imgContainerView = imgContainerView,
                let statusView = statusView,
                let usernameLabel = usernameLabel,
                let timeLabel = timeLabel {
                
                if let photo = user.getPhotoURL() {
                    imageView.af_setImage(withURL: photo)
                }

                statusView.backgroundColor = user.getStatusColor()
                statusView.layer.cornerRadius = statusView.layer.bounds.height / 2.0
                
                if user.username == User.current.username {
                    statusView.backgroundColor = UIColor.green
                }
                
                imgContainerView.layer.cornerRadius = imgContainerView.layer.bounds.height / 2.0
                imgContainerView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
                imgContainerView.layer.borderWidth = 3.0
                imgContainerView.clipsToBounds = true
                
                usernameLabel.text = model?.username
                timeLabel.text = model?.name
                

            }
        }
    }
    
    var conversation: Conversation? {
        didSet {
            if let conversation = conversation,
                let imageView = imgView,
                let imgContainerView = imgContainerView,
                let statusView = statusView,
                let usernameLabel = usernameLabel,
                let timeLabel = timeLabel {
                
                if let name = conversation.name {
                    usernameLabel.text = name
                    timeLabel.text = conversation.description
                    
                    if let url = conversation.getPhotoURL() {
                        imageView.af_setImage(withURL: url)
                        
                    }
                }else {
                    
                    if let members = conversation.members {
                        var usr = User()
                        for user in members {
                            if let username = user.username {
                                if User.current.username != username {
                                    usr = user
                                }
                            }
                        }
                        
                        usernameLabel.text = usr.username
                        timeLabel.text = usr.description
                        
                        if let url = usr.getPhotoURL() {
                            imageView.af_setImage(withURL: url)
                        }
                        
                        imgContainerView.layer.borderColor = usr.getStatusColor().cgColor

                    }
                }
                
                statusView.isHidden = true
                
                imgContainerView.layer.cornerRadius = imgContainerView.layer.bounds.height / 2.0
                imgContainerView.layer.borderWidth = 3.0
                imgContainerView.clipsToBounds = true
                
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
    
}
