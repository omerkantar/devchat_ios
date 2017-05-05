//
//  AddConversationViewController.swift
//  Gitchat
//
//  Created by omer on 25.04.2017.
//  Copyright © 2017 omer. All rights reserved.
//

import UIKit

class AddConversationViewController: BaseViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var conversation: Conversation?
    var photo: UIImage?
    
    override func viewDidLoad() {
        self.title = "Add Group"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.scrollView.delegate = self
        
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgView.bounds.size.height / 2.0
        imgButton.titleLabel?.numberOfLines = 2
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedBGView))
        tapGR.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGR)

    }

    override func isShowingNavigationBar() -> Bool {
        return true
    }
    
    func validationForm() -> Bool {
       
        if let _ = conversation,
            let name = conversation?.name,
            let desc = conversation?.description {
            
            if name.characters.count < 4 {
                return false
            }else if desc.characters.count < 4 {
                return false
            }
            
            return true
        }
        return false
    }
    
    // MARK: - Actions
    func tappedBGView() {
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
    @IBAction func tappedImgButton() {
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.delegate = self
        imgPickerVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imgPickerVC, animated: true, completion: nil)

    }
    

    @IBAction func tappedNextButton() {
        conversation = Conversation()
        conversation?.name = nameTextField.text
        conversation?.description = descriptionTextField.text
        
        if let photo = photo {
            conversation?.photo = photo
        }
        
        if validationForm() {
            let userlist = UserListViewController()
            userlist.conversation = conversation
            self.pushVC(toVC: userlist)
            
        }else {
            self.showAlertController(title: "Hata!", message: "Formu doldurunuz, name ve description en az 4 karakter olmalidir!", buttonTitles: ["Tamam"])
        }
        
    }
}

extension AddConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo = img
            self.imgView.image = photo
            self.imgButton.isHidden = true
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension AddConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
