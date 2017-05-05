//
//  ProfileViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class ProfilViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var headerView: ProfilImageHeaderView?
    var cellIdentifier = String(describing: ProfilInfoTableViewCell.self)
    
    // MARK: - Life
    override func viewDidLoad() {
        self.title = "Profil"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        headerView = ProfilImageHeaderView.create(user: User.current)
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        buildTableView(tableView: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.contentInset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 20.0, right: 0.0)
        
        
    }

    
}


extension ProfilViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProfilInfoTableViewCell
        cell.title = "Çıkış yap!"
        return cell
        
    }
}


extension ProfilViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            self.showAlertController(title: nil, message: "Çıkış yapmak istediğine emin misin?", buttonTitles: ["Eminim", "İptal"], actionCompletion: { (text, index) in
                
                if text == "Eminim" {
                    self.addLoadingView(withView: self.view)
                    UserService.logout {
                        self.removeLoadingView()
                        self.logout()
                    }
                }
            })
        }
    }
}
