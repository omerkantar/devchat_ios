//
//  ChatsViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class ChatsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var headerView: TitleHeaderView = TitleHeaderView.create(title: "Chats")

    let cellIdentifier = String(describing: UserTableViewCell.self)
    
    var list: [Conversation]?

    weak var owner: TabViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        headerView.buildButton(title: "Ekle")
        buildTableView(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        addRefreshControlToTableView(tableView: tableView)

        loadData()
        
//        headerView.tappedButtonBlock = { [weak self] () in
//            self?.addChat()
//        }
        
    }
    
    override func refreshValueChanged() {
        loadData()
        
    }

    func loadData() {
        
        self.addLoadingView(withView: self.tableView)
 
        ConversationService.getChats(success: { (list) in
            self.removeLoadingView()
            
            if let ref = self.refreshControl {
                ref.endRefreshing()
            }
            
            self.list = list
            self.tableView.reloadData()

        }) { (err) in
            self.removeLoadingView()

            if let ref = self.refreshControl {
                ref.endRefreshing()
            }
        }
    }
    
    func addChat() {
        
    }

}


extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = list {
            return list.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
       
        if let list = list {
            cell.conversation = list[indexPath.row]
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let list = list {
            let conVC = ConversationViewController()
            conVC.conversation = list[indexPath.row]
                self.pushVC(toVC: conVC)
            
        }
        
    }
    
}


