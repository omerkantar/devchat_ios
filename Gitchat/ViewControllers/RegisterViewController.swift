//
//  RegisterViewController.swift
//  Gitchat
//
//  Created by omer on 24.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var photoImage: UIImage? {
        didSet {
            if let photoImage = photoImage,
                let imgView = photoImageView {
                photoButton.isHidden = true
                imgView.image = photoImage
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        
        self.title = "Üye Ol"
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        descriptionTextField.delegate = self
        
        photoButton.titleLabel?.numberOfLines = 3
        photoButton.titleLabel?.textAlignment = .center
        
        photoContainerView.clipsToBounds = true
        
        photoContainerView.layer.cornerRadius = 45.0
        photoContainerView.layer.borderWidth = 2.0
        photoContainerView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedBGView))
        tapGR.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGR)
        
    }
    
    override func isShowingNavigationBar() -> Bool {
        return true
    }
    
    // MARK: - Build
    func validationForm(_ user: User) -> (Bool, String?) {
        
        if let username = user.username,
            let password = user.password {
           
            if ((username.characters.count) < 4) {
                return (false, "Username en az 4 karakter olmalıdır!")
            }else if ((password.characters.count) < 4) {
                return (false, "Password en az 4 karakter olmalıdır!")
            }else if photoImage == nil {
                return (false, "Fotoğraf ekleyiniz!")
            }
            return (true, nil)
        }
        
        return (false, "Username, password giriniz ve fotograf ekleyiniz!")
    }

    
    
    // MARK: - Actions
    func tappedBGView() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    
    }
    
    func getUser() -> User {
        let user = User()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.name = nameTextField.text
        user.email = emailTextField.text
        user.description = descriptionTextField.text
        return user
    }
    
    @IBAction func tappedRegisterButton() {
        
        let user = getUser()
        
        let validation = validationForm(user)
        
        if validation.0 == true {
            
            addLoadingView(withView: self.view, title: "Giris Yapılıyor")

            PhotoService.upload(image: photoImage!, type: .profil, completion: { (isSuccess, photo) in
                
                if isSuccess {
                    
                    user.photoUrl = photo?.photoUrl
                    
                    UserService.registerUser(user, success: { (me) in
                        
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
                 
                    self.removeLoadingView()
                    self.showAlertController(title: "Hata!", message: "Fotoğraf yüklenirken hata oluştu :(", buttonTitles: ["Tamam"])
                }
                
            })
            
            
        }else {
            self.showAlertController(title: "Hata!", message: validation.1, buttonTitles: ["Tamam"])
        }
    }
    
    @IBAction func tappedUploadPhotoButton() {
        
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.delegate = self
        imgPickerVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    func login(_ user: User) {
        User.current = user
        UserManager.saveUsername(username: user.username!)
        let tabVC = TabViewController()
        if let nc = navigationController {
            nc.setViewControllers([tabVC], animated: true)
        }
    }
    

}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImage = img
        }
        
        self.dismiss(animated: true, completion: nil)

    }
    
    
}


extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            nameTextField.becomeFirstResponder()
            break
        case nameTextField:
            emailTextField.becomeFirstResponder()
            break
        case emailTextField:
            descriptionTextField.becomeFirstResponder()
            break
        default:
            tappedRegisterButton()
            break
        }
        
        return true
    }
}
