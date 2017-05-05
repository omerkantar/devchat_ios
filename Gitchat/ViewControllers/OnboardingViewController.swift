//
//  OnboardingViewController.swift
//  Gitchat
//
//  Created by omer on 23.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit
import SafariServices

class OnboardingViewController: BaseViewController {

    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameTextField:UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedBGView))
        tapGR.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGR)
    }
    
    override func isShowingNavigationBar() -> Bool {
        return false
    }

    // MARK: - Build
    func getUser() -> User {
        let u = User()
        u.password = passwordTextField.text
        u.username = usernameTextField.text
        return u
    }
    func validationForm(_ user: User) -> (Bool, String?) {
        if let username = user.username,
            let password = user.password {
            if (username.characters.count < 4) {
                return (false, "Username giriniz")
            }else if (password.characters.count < 4) {
                return (false, "Password giriniz")
            }
            return (true, nil)
        }
        return (false, "Username ve password giriniz!")

    }
    
    func tappedBGView() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    @IBAction func tappedLoginButton() {

        let user = getUser()
        
        let validation = validationForm(user)
        
        if validation.0 == true {
            
            tappedBGView()
            
            addLoadingView(withView: self.view, title: "Giris Yapılıyor")

            UserService.login(user, success: { (me) in
                self.removeLoadingView()
                
                self.login(me)
                
            }, failure: { (err) in
                self.removeLoadingView()

                var message = "Bir hata yasandi! :("
                if let msg = err?.message {
                    message = msg
                }
                
                self.showAlertController(title: "Hata!", message: message, buttonTitles: ["Tamam"], actionCompletion: nil)

            })
            
        }else {
            self.showAlertController(title: "Hata!", message: validation.1, buttonTitles: ["Tamam"], actionCompletion: nil)
        }
    }

    @IBAction func tappedRegisterButton() {
        let registerVC = RegisterViewController()
        pushVC(toVC: registerVC)
    }
    
    func login(_ user: User) {
        User.current = user
        if let txt = usernameTextField.text {
            UserManager.saveUsername(username: txt)
        }
        let tabVC = TabViewController()
        if let nc = navigationController {
            nc.viewControllers = [tabVC]
            
        }
    }
}


extension OnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
            break
        default:
            self.tappedLoginButton()
            break
        }
        return true
    }
}
