//
//  UsersViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class UsersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = String(describing: UserTableViewCell.self)
    var users: [User]?
    var headerView = TitleHeaderView.create(title: "Users")
    
    weak var owner: TabViewController?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        buildTableView(tableView: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.contentInset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0)
        loadData()
        addRefreshControlToTableView(tableView: tableView)
   
    }

    override func refreshValueChanged() {
        loadData()
    }
    
    // MARK: - Build
    func loadData() {
        
        addLoadingView(withView: self.tableView)
        
        UserService.allUsers({ (list) in
            self.removeLoadingView()
            self.users = list
            self.tableView.reloadData()
            
            if let ref = self.refreshControl {
                ref.endRefreshing()
            }
            
        }) { (err) in
            self.removeLoadingView()
            if let ref = self.refreshControl {
                ref.endRefreshing()
            }
        }
        
    }
    
    
    
    
}


extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let list = users {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        if let users = users {
            cell.model = users[indexPath.row]
            
        }

        
        return cell
        
    }
    
}


extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let list = users {
            let user = list[indexPath.row]
            
            if let name = user.username {
                
                let conversation = Conversation()
                
                conversation.membersUsername = [name]
                
                self.addLoadingView(withView: self.view)
                
                ConversationService.save(con: conversation, success: { (con) in
                    
                    if let owner = self.owner {
                        owner.updateChats()
                    }
                    
                    self.removeLoadingView()
                    
                    self.pushConversationVC(con: con)
                }, failure: { (err) in
                    
                    self.removeLoadingView()
                })

            }
        }
    }
}
