//
//  UserProfileController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UIViewController {
    
    let userProfileContainerView = UserProfileContainerView()
    let avatarOpener = AvatarOpener()
    let userProfileDataDatabaseUpdater = UserProfileDataDatabaseUpdater()
    typealias CompletionHandler = (_ success: Bool) -> Void
    
    var Done: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        view.addSubview(userProfileContainerView)
        
        Done = RoundedButton(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
        Done.setTitleColor(UIColor.white, for: .normal)
        Done.setTitle("Done", for: .normal)
        Done.center = CGPoint(x: view.center.x, y: view.frame.height - Done.frame.height - 230)
        Done.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        Done.defaultColor = secondaryColor
        Done.addTarget(self, action: #selector(rightBarButtonDidTap), for: .touchUpInside)
        
        view.addSubview(Done)
        
        configureNavigationBar()
        configureContainerView()
        configureColorsAccordingToTheme()
    }
    
    fileprivate func configureNavigationBar () {
        let rightBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(rightBarButtonDidTap))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.title = "Profile"
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    fileprivate func configureContainerView() {
        userProfileContainerView.frame = view.bounds
        userProfileContainerView.bioPlaceholderLabel.isHidden = !userProfileContainerView.bio.text.isEmpty
        userProfileContainerView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openUserProfilePicture)))
        userProfileContainerView.bio.delegate = self
        userProfileContainerView.name.delegate = self
    }
    
    fileprivate func configureColorsAccordingToTheme() {
        userProfileContainerView.profileImageView.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
        userProfileContainerView.userData.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
        userProfileContainerView.name.textColor = ThemeManager.currentTheme().generalTitleColor
        userProfileContainerView.bio.layer.borderColor = ThemeManager.currentTheme().inputTextViewColor.cgColor
        userProfileContainerView.bio.textColor = ThemeManager.currentTheme().generalTitleColor
        userProfileContainerView.bio.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
        userProfileContainerView.name.keyboardAppearance = ThemeManager.currentTheme().keyboardAppearance
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userProfileContainerView.frame = view.bounds
        userProfileContainerView.layoutIfNeeded()
    }
    
    @objc fileprivate func openUserProfilePicture() {
        guard currentReachabilityStatus != .notReachable else {
            basicErrorAlertWith(title: basicErrorTitleForAlert, message: noInternetError, controller: self)
            return
        }
        avatarOpener.delegate = self
        avatarOpener.handleAvatarOpening(avatarView: userProfileContainerView.profileImageView, at: self,
                                         isEditButtonEnabled: true, title: .user)
    }
}

extension UserProfileController {
    
    @objc func rightBarButtonDidTap () {
        userProfileContainerView.name.resignFirstResponder()
        if userProfileContainerView.name.text?.count == 0 ||
            userProfileContainerView.name.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            userProfileContainerView.name.shake()
        } else {
            
            if currentReachabilityStatus == .notReachable {
                basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
                return
            }
            
//            updateUserData()
            setOnlineStatus()
        }
    }
    
    func checkIfUserDataExists(completionHandler: @escaping CompletionHandler) {
        
        let nameReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("name")
        nameReference.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.userProfileContainerView.name.text = snapshot.value as? String
            }
        })
        
        let bioReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("bio")
        bioReference.observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                self.userProfileContainerView.bio.text = snapshot.value as? String
            }
        })
        
        
        let photoReference = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("photoURL")
        photoReference.observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                let urlString:String = snapshot.value as! String
                self.userProfileContainerView.profileImageView.sd_setImage(with:  URL(string: urlString) , placeholderImage: nil, options: [.scaleDownLargeImages , .continueInBackground], completed: { (image, error, cacheType, url) in
                    
                    completionHandler(true)
                })
            } else {
                
                completionHandler(true)
            }
        })
    }
    
    func updateUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ARSLineProgress.ars_showOnView(self.view)
        
        let userReference = Database.database().reference().child("users/\(uid)").child(Auth.auth().currentUser!.uid)
        userReference.updateChildValues(["phoneNumber" : userProfileContainerView.phone.text!]) { (error, reference) in
                                            ARSLineProgress.hide()
                                            self.dismiss(animated: true) {
                                                AppUtility.lockOrientation(.allButUpsideDown)
                                            }
        }
    }
}

extension UserProfileController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        userProfileContainerView.bioPlaceholderLabel.isHidden = true
        userProfileContainerView.countLabel.text = "\(userProfileContainerView.bioMaxCharactersCount - userProfileContainerView.bio.text.count)"
        userProfileContainerView.countLabel.isHidden = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        userProfileContainerView.bioPlaceholderLabel.isHidden = !textView.text.isEmpty
        userProfileContainerView.countLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.isFirstResponder && textView.text == "" {
            userProfileContainerView.bioPlaceholderLabel.isHidden = true
        } else {
            userProfileContainerView.bioPlaceholderLabel.isHidden = !textView.text.isEmpty
        }
        userProfileContainerView.countLabel.text = "\(userProfileContainerView.bioMaxCharactersCount - textView.text.count)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return textView.text.count + (text.count - range.length) <= userProfileContainerView.bioMaxCharactersCount
    }
}

extension UserProfileController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

