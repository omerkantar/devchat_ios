//
//  BaseViewController.swift
//  Gitchat
//
//  Created by omer on 22.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var statusBarBGView: UIView?

    var refreshControl: UIRefreshControl?
    
    var loadingView: LoadingView?

    var emptyDescriptionView: EmptyDescriptionView?

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarDesigning()
        build()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationBarClearBackgroundColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBarClearBackgroundColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBarUpdatedBackgroundColor()
    }
    
    // MARK: - Design
    
    // MARK: - Build
    func build() {
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 20.0)
        statusBarBGView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        statusBarBGView?.backgroundColor = UIColor.clear
        
        view.addSubview(statusBarBGView!)
        view.bringSubview(toFront: statusBarBGView!)
    }
    
    func buildTableView(tableView: UITableView) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.contentInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func addRefreshControlToTableView(tableView: UITableView) {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.groupTableViewBackground
        refreshControl?.addTarget(self, action: #selector(refreshValueChanged), for: .valueChanged)
        
        tableView.addSubview(refreshControl!)
        
    }
    
    func refreshValueChanged() {
        
    }
    
    // MARK: - NavigationBar Designing
    func isShowingNavigationBar() -> Bool {
        return false
    }
    
    
    func navigationBarClearBackgroundColor() {
        if let navigationController = navigationController {
            let navigationBar = navigationController.navigationBar
            navigationBar.backgroundColor = UIColor.clear
            
            if let status = statusBarBGView {
                status.backgroundColor = UIColor.clear
            }
        }
    }
    
    func navigationBarUpdatedBackgroundColor() {
        if let nc = navigationController {
            if self.isShowingNavigationBar() {
                let navigationBar = nc.navigationBar
                navigationBar.backgroundColor = UIColor.white

            }
        }
    }
    
    func getNavigationBarRightButtonTitle() -> String? {
        return nil
    }
    
    func navigationBarDesigning() {
        if let nc = self.navigationController {
            self.automaticallyAdjustsScrollViewInsets = false

            let navigationBar = nc.navigationBar
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            navigationBar.backIndicatorImage = UIImage()
            navigationBar.backgroundColor = UIColor.clear
            navigationBar.tintColor = UIColor.clear
            navigationBar.barTintColor = UIColor.clear
            
            
            if self.isShowingNavigationBar() == true {
                let blue = UIColor(red:0/255.0, green:126/255.0, blue:246/255.0, alpha: 1)

                navigationBar.tintColor = blue
                
                if (nc.viewControllers.count > 1) {
                    self.automaticallyAdjustsScrollViewInsets = true
                    
                    let backItem = UIBarButtonItem()
                    backItem.title = "Back"
                    nc.navigationItem.backBarButtonItem = backItem
//
//
                }
                
                if let rightButtonTitle = self.getNavigationBarRightButtonTitle() {
                    
                    
                    navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(tappedRightButton))

                    
                }

            }
            
        }
    }
    
    
    
    // MARK: - AlertView
    func showAlertController(title: String?, message: String?, buttonTitles: [String], actionCompletion: ((_ buttonTitle: String, _ index: Int) -> ())? = nil) {
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for title in buttonTitles {
            
            let action = UIAlertAction(title: title, style: .default, handler: { (act: UIAlertAction) in
                if let actionCompletion = actionCompletion {
                    actionCompletion(title, alertController.actions.index(of: act)!)
                }
            })
            alertController.addAction(action)
        }
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showActionSheetController(title: String?, message: String?, buttonTitles: [String], actionCompletion: ((_ buttonTitle: String, _ index: Int) -> ())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        for title in buttonTitles {
            
            let action = UIAlertAction(title: title, style: .default, handler: { (act: UIAlertAction) in
                if let actionCompletion = actionCompletion {
                    actionCompletion(title, alertController.actions.index(of: act)!)
                }
            })
            alertController.addAction(action)
        }
        
        
        alertController.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - NavigationController Methods
    
    func tappedRightButton() {
        
    }
    
    func pushVC(toVC vc: UIViewController) {
        if let nc = self.navigationController {
            nc.pushViewController(vc, animated: true)
        }
    }
    
    func popVC() {
        if let nc = self.navigationController {
            nc.popViewController(animated: true)
        }
    }
    
    func successConversation(con: Conversation) {
        
        
        let notification = Notification()
        notification.conversation = con
        notification.type = .success
        
        NotificationView.show(withNotification: notification, tappedBlock: nil)
        
        
        if let nc = navigationController {
            nc.setViewControllers([TabViewController()], animated: true)
        }
    }
    
    
    func pushConversationVC(con: Conversation) {
        let conVC = ConversationViewController()
        conVC.conversation = con
        self.pushVC(toVC: conVC)

    }
    
    func tappedNotificationView(notification: Notification?, title: String?) { }
    
    // MARK: - Navigation
    func logout() {
        SocketService.manager.emitStatus(status: "offline")
        if let nc = self.navigationController as? NavigationViewController {
            UserService.logout {
                UserManager.logout()
                let onVC = OnboardingViewController()
                nc.setViewControllers([onVC], animated: false)
            }
        }
    }
}

extension BaseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 15 {
            if let status = statusBarBGView {
                status.backgroundColor = UIColor.white
            }
        }else {
            statusBarBGView?.backgroundColor = UIColor.clear
        }
    }
}


// MARK: - LOADING & EMPTY VIEW VIEW

extension BaseViewController {
    // MARK: - Loading View
    func addLoadingView(withView ownerView: UIView, title: String? = nil) {
        
        removeEmptyDescriptionView()
        
        removeLoadingView()
        
        loadingView = LoadingView.create(title: title)
        
        var ownerFrame = ownerView.frame
        
        ownerFrame.origin = CGPoint.zero
        
        loadingView?.frame = ownerFrame
        
        ownerView.addSubview(loadingView!)
        
        
        loadingView?.startAnimating()
    }
    
    func removeLoadingView() {
        if let loadingView = loadingView {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    
    // MARK: - EmptyDescriptionView
    func addEmptyDescriptionView(withDescription info: String, ownerView: UIView) {
        
        removeLoadingView()
        
        removeEmptyDescriptionView()
        
        emptyDescriptionView = EmptyDescriptionView.create(withDescription: info)
        
        var ownerFrame = ownerView.frame
        
        ownerFrame.origin = CGPoint.zero
        
        emptyDescriptionView?.frame = ownerFrame
        
        ownerView.addSubview(emptyDescriptionView!)
        
        emptyDescriptionView?.tappedDescriptionViewBlock = { [weak self] () in
            
            self?.tappedEmptyDescriptionView()
        }
        
    }
    
    func removeEmptyDescriptionView() {
        if let emptyDescriptionView = emptyDescriptionView {
            emptyDescriptionView.removeFromSuperview()
        }
    }
    
    
    func tappedEmptyDescriptionView() {}

}
