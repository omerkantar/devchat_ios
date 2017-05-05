//
//  ConversationViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class ConversationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let cellIdentifier = String(describing: MessageTableViewCell.self)
    let cellidentifierImg = String(describing: MessageImageTableViewCell.self)
    
    var conversation: Conversation?
    
    var photo: UIImage?
    
    var list: [MessageCellViewModel]?
    
    var socket: SocketService?
    
    var canLoading: Bool = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        socket = SocketService()
        socket?.connect()
        socket?.delegate = self
        
        textField.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: cellidentifierImg, bundle: nil), forCellReuseIdentifier: cellidentifierImg)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(40.0, 0.0, 5.0, 0.0)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.layoutIfNeeded()
        loadData()
        addRefreshControlToTableView(tableView: tableView)

        if let conversation = conversation {
            self.title = conversation.name
        }
        
    }

    override func refreshValueChanged() {
        loadData()
    }
    
    override func isShowingNavigationBar() -> Bool {
        return true
    }
    
    // MARK: - Build
    
    func loadData() {
        
        if let con = conversation,
            let _ = con.id {
            
            
            self.addLoadingView(withView: self.tableView)
            
            ConversationService.getDetail(con: con, success: { (conversation) in
                
                if let ref = self.refreshControl {
                    ref.endRefreshing()
                }
                
                self.removeLoadingView()
                
                self.conversation = conversation
                
                self.list = [MessageCellViewModel]()
                
                if let arr = conversation.messages {
                    for msg in arr {
                        
                        let vm = MessageCellViewModel(message: msg)
                        vm.isGroup = con.isGroup
                        self.list?.append(vm)
                    }
                }
                
                
                self.tableView.reloadData()
                self.scrollingLastIndexPath()
                self.canLoading = true
                
            }, failure: { (err) in
                self.removeLoadingView()
                if let ref = self.refreshControl {
                    ref.endRefreshing()
                }
                self.canLoading = true
                
            })
            
        }

    }
    
    func scrollingLastIndexPath() {
        
        if let tv = tableView {
            
            if let list = list {
                if list.count < 5 {
                    return
                }
            }
            
            
            if list == nil {
                return
            }
            
            if let count = list?.count {
            
                let lastIndexPath = IndexPath(row: count - 1, section: 0)
                
                tv.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
            
            
            
        }
    }
    
    func createMessage(text: String?, photoUrl: String?) -> Message {
        
        let msg = Message()
        msg.conversation = conversation
        
        if let conversation = conversation {
            msg.conversationId = conversation.id
        }
        
        if let text = text {
            msg.text = text
        }
        
        
        if let photoUrl = photoUrl {
            msg.photoUrl = photoUrl
        }
        
        if let username = UserManager.getUserName() {
            msg.author = User()
            msg.author?.username = username
            
        }
        
        return msg
    }
    
    // MARK: - Actions
    
    @IBAction func tappedAddButton() {
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.delegate = self
        imgPickerVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imgPickerVC, animated: true, completion: nil)

    }
    
    @IBAction func tappedSendButton() {
        
        
        if let text = textField.text {
            let msg = createMessage(text: text, photoUrl: nil)
            emitMessage(message: msg)
        }
    }
    
    func emitMessage(message: Message) {

        self.textField.text = ""
        message.conversationId = conversation?.id
        let vm = MessageCellViewModel(message: message)
        
        list?.append(vm)
        tableView.reloadData()
        self.scrollingLastIndexPath()
        socket?.emitMessage(message: message)
    }
    
}

// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = list {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let list = list {
            let vm = list[indexPath.row]
            if vm.hasUrl {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifierImg, for: indexPath) as! MessageImageTableViewCell
                cell.viewModel = vm
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableViewCell
        
        cell.viewModel = list?[indexPath.row]
        
        return cell
    }
    
  
}


// MARK: - Photo

extension ConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func loadPhoto() {
        if let photo = photo {
            
            self.addLoadingView(withView: self.tableView)
            
            PhotoService.upload(image: photo, type: .message, completion: { (state, model) in
                
                self.removeLoadingView()
                
                if state {
                    print(model)
                    
                    let msg = self.createMessage(text: nil, photoUrl: model?.photoUrl)
                    self.emitMessage(message: msg)
                    
                }else {
                    
                    self.showAlertController(title: "Hata!", message: "Fotograf yuklenirken hata olustu!", buttonTitles: ["Tamam"])
                }
                
            })
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.photo = img
            loadPhoto()
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}


// MARK: - TextField

extension ConversationViewController: UITextFieldDelegate {
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let const = self.bottomConstraint {
            const.constant = 214.0
//            view.updateCon    straintsIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let const = self.bottomConstraint {
            const.constant = 0.0
//            view.updateConstraintsIfNeeded()
        }
        
    }
}


extension ConversationViewController: SocketDelegate {
    func socket(socket: SocketService, onType: SocketOnType) {
        if onType == .message {
            if self.canLoading == true {
                self.loadData()
            }
        }
    }
}


