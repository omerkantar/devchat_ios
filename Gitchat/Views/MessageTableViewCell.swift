//
//  MessageTableViewCell.swift
//  Gitchat
//
//  Created by omer on 23.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import AlamofireImage

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var viewModel: MessageCellViewModel? {
        didSet {
            if let viewModel = viewModel,
                let usernameLabel = usernameLabel,
                let messageLabel = messageLabel,
                let timeLabel = timeLabel,
                let containerView = containerView {
                
                timeLabel.text = viewModel.time
                containerView.layer.borderColor = UIColor.gray.cgColor
                containerView.layer.borderWidth = 0.5
                containerView.layer.cornerRadius = 5.0
                
                usernameLabel.text = viewModel.username
                messageLabel.text = viewModel.message

                
                if (viewModel.isCurrent) {
                    //left
                    rightConstraint.constant = 8.0
                    leftConstraint.constant = 45.0
                }else {
                    //right
                    rightConstraint.constant = 45.0
                    leftConstraint.constant = 8.0
                }
                
                self.layoutIfNeeded()
                
                
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
