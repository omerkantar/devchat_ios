//
//  ProfilInfoTableViewCell.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class ProfilInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
  
    
    var title: String? {
        didSet {
            if let title = title,
                let titleLabel = titleLabel {
                titleLabel.text = title
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
