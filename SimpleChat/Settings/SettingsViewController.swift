//
//  SettingsViewController.swift
//  SimpleChat
//
//  Created by Robert Brennan on 1/15/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation
import AccountKit
import Firebase
import LBTAComponents


class SettingsViewController: UIViewController{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    var accountKit: AKFAccountKit!
    let userName = Auth.auth().currentUser?.displayName
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet var logoutButton: RoundedButton!
    
    let profileImageViewHeight: CGFloat = 170
    lazy var profileImageView: CachedImageView = {
        var iv = CachedImageView()
        iv.backgroundColor = LoginButtons.baseColor
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = profileImageViewHeight / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userName)
        print(uid)
        
        logoutButton.addTarget(self, action: #selector(handleSignOutButtonTapped), for: .touchUpInside)
        setupviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        handleFetchFacebookUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    fileprivate func setupviews(){
        view.addSubview(profileImageView)
        view.addSubview(logoutButton)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.setTitle("Logout", for: .normal)
        profileImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: view.center.x - (profileImageViewHeight/2), bottomConstant: 0, rightConstant: 0, widthConstant: profileImageViewHeight, heightConstant: profileImageViewHeight)
        
        logoutButton.defaultColor = primaryColor1
        if UIScreen.main.nativeBounds.height == 1792{
            //Iphones = Xr
            logoutButton.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
        }
        else if UIScreen.main.nativeBounds.height == 2436{
            //Iphones = Xs/ X
            logoutButton.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
        }
        else if UIScreen.main.nativeBounds.height == 2688{
            //Iphones = Xs MAX
            logoutButton.center = CGPoint(x: view.center.x, y: view.frame.height - 150)
        }
        else{
            //Iphones = Xs MAX
            logoutButton.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        }
    }

    
    //Fetch User Information
    func  handleFetchFacebookUser() {
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("------------------------")
            print("Current user is: " + uid)
            print("------------------------")
            Database.database().reference().child("users").child(uid).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                let user = FacebookUser(uid: uid, dictionary: dictionary)
                
                self.nameLabel.text = user.name
                self.profileImageView.loadImage(urlString: user.profileImageUrl)

            }, withCancel: { (err) in
                print("canceled")
            })
        }
        
        if accountKit == nil {
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount {
                (account, error) -> Void in
                
                if let phoneNumber = account?.phoneNumber{
                    self.numberLabel.text = phoneNumber.stringRepresentation()
                }
            }
        }
    }
    
    @objc func handleSignOutButtonTapped() {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            do {
                self.accountKit.logOut()
                try Auth.auth().signOut()

                self.dismiss(animated: true, completion: nil)
            } catch let err {
                print("Failed to sign out with error", err)
                LoginButtons.showAlert(on: self, style: .alert, title: "Sign Out Error", message: err.localizedDescription)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        LoginButtons.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
}
