//
//  MessageImageTableViewCell.swift
//  Gitchat
//
//  Created by omer on 27.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class MessageImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!

    
    var viewModel: MessageCellViewModel? {
        didSet {
            if let viewModel = viewModel,
                let usernameLabel = usernameLabel,
                let containerView = containerView,
                let timeLabel = timeLabel,
                let leftConst = leftConstraint,
                let rightConst = rightConstraint {

                
                usernameLabel.text = viewModel.username
                timeLabel.text = viewModel.time
                containerView.layer.borderColor = UIColor.gray.cgColor
                containerView.layer.borderWidth = 0.5
                containerView.layer.cornerRadius = 5.0

                
                if (viewModel.isCurrent) {
                    //left
                    rightConst.constant = 8.0
                    leftConst.constant = 45.0
                }else {
                    //right
                    rightConst.constant = 45.0
                    leftConst.constant = 8.0
                }
                

                imgView.image = nil
                imgView.af_setImage(withURL: (viewModel.photoURL)!)
                imgView.layer.cornerRadius = 5.0
                imgView.clipsToBounds = true
                imgView.layer.borderWidth = 2.0
                imgView.layer.borderColor = UIColor.groupTableViewBackground.cgColor


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
