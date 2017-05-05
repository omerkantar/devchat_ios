//
//  GroupsViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class GroupsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var headerView: TitleHeaderView = TitleHeaderView.create(title: "Groups")
    
    let cellIdentifier = String(describing: GroupItemTableViewCell.self)
    
    var list: [Conversation]?
    
    weak var owner: TabViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        headerView.buildButton(title: "Ekle")
        buildTableView(tableView: tableView)
        tableView.tableHeaderView = headerView
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        addRefreshControlToTableView(tableView: tableView)
        
        loadData()
        
        headerView.tappedButtonBlock = { [weak self] () in
            self?.pushAddGroupVC()
        }
    }
    
    // MARK: - Build
    
    override func refreshValueChanged() {
        loadData()
    }
    
    func loadData() {
        
        self.addLoadingView(withView: self.tableView)
        
        
        ConversationService.getGroups(success: { (list) in
        
            if let ref = self.refreshControl {
                ref.endRefreshing()
            }
            
            self.removeLoadingView()
            self.list = list
            self.tableView.reloadData()
            
        }) { (err) in
            self.removeLoadingView()
            
            if let ref = self.refreshControl {
                ref.endRefreshing()
            }
        }
    }
    
    
    // MARK: - Actions
    func pushAddGroupVC() {
        let add = AddConversationViewController()
        pushVC(toVC: add)
    }
    
}


extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = list {
            return list.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GroupItemTableViewCell
        
        if let list = list {
            cell.model = list[indexPath.row]
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
