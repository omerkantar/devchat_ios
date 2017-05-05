//
//  UserListViewController.swift
//  Gitchat
//
//  Created by omer on 26.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class UserListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = String(describing: SelectItemTableViewCell.self)
    
    var conversation: Conversation?
    var list: [SelectItem]?
    var selectedNameList: [String]?
    
    override func viewDidLoad() {
        self.title = "Add Members"
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.dataSource = self
        tableView.delegate = self
        buildTableView(tableView: tableView)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.contentInset = UIEdgeInsetsMake(40.0, 0.0, 20.0, 0.0)
        
        loadData()
        
    }

    override func isShowingNavigationBar() -> Bool {
        return true
    }
    
    func loadData() {
        
        addLoadingView(withView: self.tableView)
        
        UserService.allUsers({ (users) in
            
            self.removeLoadingView()
            
            self.list = [SelectItem]()
            
            for user in users {
                if let username = user.username {
                    if User.current.username != username {
                        let item = SelectItem()
                        item.title = username
                        item.model = user
                        self.list?.append(item)
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }) { (err) in
            
        }
    }
    
    func validation() -> Bool {
        
        if let list = list {
            selectedNameList = [String]()
            for item in list {
                if item.isSelected {
                    if let title = item.title {
                        selectedNameList?.append(title)
                    }
                }
            }
            
            if (selectedNameList?.count)! >= 2 {
                return true
            }
        }
        
        
        return false
        
    }
    
    @IBAction func tappedNew() {
        
        if validation() {
            
            self.addLoadingView(withView: self.view)
            
            conversation?.membersUsername = selectedNameList
            
            if let photo = conversation?.photo {
                
                PhotoService.upload(image: photo, type: .message, completion: { (state, model) in
                    
                    if (state) {
                      self.conversation?.photoUrl = model?.photoUrl
                    }else {
                        //
                    }
                    
                    ConversationService.save(con: self.conversation!, success: { (con) in
                        self.removeLoadingView()
                        // SUCCESS
                        self.successConversation(con: con)
                        
                        
                    }, failure: { (err) in
                        self.removeLoadingView()
                        self.showAlertController(title: "Hata", message: "Grup oluşturulamadı!", buttonTitles: ["Tamam"])
                    })
                })
            }
            
        }else {
            
        }
        
    }
    
}


extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = list {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SelectItemTableViewCell
        
        if let list = list {
            cell.model = list[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let list = list {
            let model = list[indexPath.row]
            model.isSelected = !(model.isSelected)
            tableView.reloadData()
        }
    }
}
