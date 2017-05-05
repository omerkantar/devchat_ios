//
//  TitleHeaderView.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class TitleHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var tappedButtonBlock: (() -> ())?
    
    class func create(title: String) -> TitleHeaderView {
        let nibName = String(describing: TitleHeaderView.self)
        let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! TitleHeaderView
        view.button.isHidden = true
        view.titleLabel.text = title
        return view
    }
    
    func buildButton(title: String) {
        button.setTitle(title, for: .normal)
        button.isHidden = false 
    }
    
    @IBAction func tappedButton() {
        if let block = tappedButtonBlock {
            block()
        }
    }
    
}
