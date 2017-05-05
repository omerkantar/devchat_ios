//
//  TabViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class TabViewController: BaseViewController {

    @IBOutlet weak var groupsButton: UIButton!
    @IBOutlet weak var chatsButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var profilButton: UIButton!
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    var groupsVC: GroupsViewController?
    var chatsVC: ChatsViewController?
    var usersVC: UsersViewController?
    var profilVC: ProfilViewController?
    
    var vcs: [UIViewController]?
    
    var socket: SocketService?
    
    var activeButton: UIButton?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SocketService.manager.connect()

        groupsVC = GroupsViewController()
        groupsVC?.owner = self
        
        chatsVC = ChatsViewController()
        chatsVC?.owner = self
        
        usersVC = UsersViewController()
        usersVC?.owner = self
        
        profilVC = ProfilViewController()
        
        vcs = [groupsVC!, chatsVC!, usersVC!, profilVC!]
        
        self.tabBarView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { 
            
            let screenSize = UIScreen.main.bounds.size
            if let vcs = self.vcs {
                for vc in vcs {
                    vc.view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: screenSize.width, height: screenSize.height - 55.0))
                    self.addChildViewController(vc)
                    self.contentView.addSubview((vc.view)!)
                }
            }
            
            self.tabBarView.isUserInteractionEnabled = true

            self.activeButton = self.profilButton
            self.selectedBottomBarButton(btn: self.groupsButton, vc: (self.groupsVC)!)
            

        }
        
        socket = SocketService()
        socket?.delegate = self
        socket?.connect()
        socket?.emitStatus(status: "online")
        
    }

    override func isShowingNavigationBar() -> Bool {
        return false
    }
    
    
    
    // MARK: - Actions
    @IBAction func tappedGroupsButton() {
        self.selectedBottomBarButton(btn: groupsButton, vc: (groupsVC)!)
    }
    
    @IBAction func tappedChatsButton() {
        self.selectedBottomBarButton(btn: chatsButton, vc: (chatsVC)!)
    }
    
    @IBAction func tappedUsersButton() {
        self.selectedBottomBarButton(btn: usersButton, vc: (usersVC)!)
    }
    
    @IBAction func tappedProfilButton() {
        self.selectedBottomBarButton(btn: profilButton, vc: (profilVC)!)
    }
    
    
    func selectedBottomBarButton(btn: UIButton, vc: BaseViewController) {
        if btn == activeButton {
            return
        }
        self.contentView.bringSubview(toFront: (vc.view))
        designingNotActiveButton(btn: activeButton!)
        activeButton = btn
        designingActiveButton(btn: activeButton!)
        
    }
    
    func designingActiveButton(btn: UIButton) {
        let blue = UIColor(red:0/255.0, green:126/255.0, blue:246/255.0, alpha: 1)
        
        btn.setTitleColor(blue, for: .normal)
    }
    
    func designingNotActiveButton(btn: UIButton) {
        btn.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    func updateStatus() {
        usersVC?.loadData()
    }
    
    func updateGroups() {
        groupsVC?.loadData()
    }
    
    func updateChats() {
        chatsVC?.loadData()
    }
    

}


extension TabViewController: SocketDelegate {
    func socket(socket: SocketService, onType: SocketOnType) {
        if onType == .status {
            if let users = usersVC {
                users.loadData()
            }
        }
    }
}
