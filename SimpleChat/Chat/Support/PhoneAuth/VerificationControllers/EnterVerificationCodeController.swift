//
//  EnterVerificationCodeController.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit
import Firebase


class EnterVerificationCodeController: UIViewController {
    
    let enterVerificationContainerView = EnterVerificationContainerView()
    // var phoneNumberControllerType: PhoneNumberControllerType = .authentication
    
    var Verify:RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        view.addSubview(enterVerificationContainerView)
        enterVerificationContainerView.frame = view.bounds
        enterVerificationContainerView.resend.addTarget(self, action: #selector(sendSMSConfirmation), for: .touchUpInside)
        enterVerificationContainerView.enterVerificationCodeController = self
        
        Verify = RoundedButton(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
        Verify.setTitleColor(UIColor.white, for: .normal)
        Verify.setTitle("Verify", for: .normal)
        Verify.center = CGPoint(x: view.center.x, y: view.frame.height - Verify.frame.height - 230)
        Verify.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        Verify.defaultColor = primaryColor1
        Verify.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        
        view.addSubview(Verify)
        
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar () {
        self.navigationItem.hidesBackButton = true
    }
    
    func setRightBarButton(with title: String) {
        let rightBarButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightBarButtonDidTap))
//        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc fileprivate func sendSMSConfirmation () {
        
        if currentReachabilityStatus == .notReachable {
            basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
            return
        }
        
        enterVerificationContainerView.resend.isEnabled = false
        print("tappped sms confirmation")
        
        let phoneNumberForVerification = enterVerificationContainerView.titleNumber.text!
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberForVerification, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                basicErrorAlertWith(title: "Error", message: error.localizedDescription + "\nPlease try again later.", controller: self)
                return
            }
            
            print("verification sent")
            self.enterVerificationContainerView.resend.isEnabled = false
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.enterVerificationContainerView.runTimer()
        }
    }
    
    @objc func rightBarButtonDidTap () {
        
    }
    
    func changeNumber () {
        enterVerificationContainerView.verificationCode.resignFirstResponder()
        let verificationID = UserDefaults.standard.string(forKey: "ChangeNumberAuthVerificationID")
        let verificationCode = enterVerificationContainerView.verificationCode.text
        
        if verificationID == nil {
            self.enterVerificationContainerView.verificationCode.shake()
            return
        }
        
        if currentReachabilityStatus == .notReachable {
            basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
            return
        }
        
        ARSLineProgress.ars_showOnView(self.view)
        
        let credential = PhoneAuthProvider.provider().credential (withVerificationID: verificationID!, verificationCode: verificationCode!)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }

        
        Auth.auth().currentUser?.updatePhoneNumber(credential, completion: { (error) in
            if error != nil {
                ARSLineProgress.hide()
                basicErrorAlertWith(title: "Error", message: error?.localizedDescription ?? "Number changing process failed. Please try again later.", controller: self)
                return
            }
            
            let userReference = Database.database().reference().child("users/\(uid)").child(Auth.auth().currentUser!.uid)
            userReference.updateChildValues(["phoneNumber" : self.enterVerificationContainerView.titleNumber.text! ]) { (error, reference) in
                if error != nil {
                    ARSLineProgress.hide()
                    basicErrorAlertWith(title: "Error", message: error?.localizedDescription ?? "Number changing process failed. Please try again later.", controller: self)
                    return
                }
                
                ARSLineProgress.showSuccess()
                self.dismiss(animated: true) {
                    AppUtility.lockOrientation(.allButUpsideDown)
                }
            }
        })
    }
    
    @objc func authenticate() {
        print("tapped")
        enterVerificationContainerView.verificationCode.resignFirstResponder()
        if currentReachabilityStatus == .notReachable {
            basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
            return
        }
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let verificationCode = enterVerificationContainerView.verificationCode.text
        
        if verificationID == nil {
            ARSLineProgress.showFail()
            self.enterVerificationContainerView.verificationCode.shake()
            return
        }
        
        if currentReachabilityStatus == .notReachable {
            basicErrorAlertWith(title: "No internet connection", message: noInternetError, controller: self)
        }
        
        ARSLineProgress.ars_showOnView(self.view)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let credential = PhoneAuthProvider.provider().credential (
            withVerificationID: verificationID!,
            verificationCode: verificationCode!)
        
        Auth.auth().currentUser?.updatePhoneNumber(credential, completion: { (error) in
            
            if error != nil {
                ARSLineProgress.hide()
                basicErrorAlertWith(title: "Error", message: error?.localizedDescription ?? "Oops! Something happened, try again later.", controller: self)
                return
            }
        let phoneNumberForVerification = self.enterVerificationContainerView.titleNumber.text!

        
        let databaseRef = Database.database().reference().child("users/\(uid)/phone")
        
        let userObject = [
            "phoneNumber": phoneNumberForVerification,
            ] as [String:Any]
        databaseRef.updateChildValues(userObject)
        
        self.initialSupportMessage()

        
        AppUtility.lockOrientation(.portrait)

        ARSLineProgress.hide()
        
        print("code is correct")
//        let destination = AuthPhoneNumberController()
//        self.dismiss(animated: true){
//        destination.dismiss(animated: true, completion: nil)
        
//            }
        })
    }
    
    
    //Direct Line of Contact for User and Admin
    
    func initialSupportMessage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Add Info to messages folder
        let databaseRef = Database.database().reference().child("messages")
        let childRef = databaseRef.childByAutoId()
        let key = childRef.key
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        guard let name = Auth.auth().currentUser?.displayName else { return }
        let Peace = "\u{270C}"

        let userObject = [
            key:[
                "fromId":           "\(adminUID)",
                "messageUID":       key,
                "seen":             false,
                "status":           "Delivered",
                "text":             "Hi \(name) \(Peace),\n\nWelcome to Subly! We hope you find our app to be useful in your house hunt. We know searching for just the right place can be a hassle, so we'll do everything we can to alleviate the process. To help with any questions or suggestions you may have, we went ahead and set up this direct line of contact with our team! We're working around the clock to keep our users satisfied and will strive to respond within 24 hrs of receiving any messages. The best of luck in finding the right house and we look forward to hearing from you :)",
                "timestamp":        timestamp,
                "toId":             "\(uid)",
                
            ]
            ] as [String:Any]
        
        databaseRef.updateChildValues(userObject)
        
        //Add Info to messages folder
        
        let databaseRef1 = Database.database().reference().child("user-messages/\(uid)/\(adminUID)")
        
        
        let userObject1 = [
            "metaData":[
                "badge":                0,
                "chatID":               "\(uid)",
                "isGroupChat":          false,
                "lastMessageID":        key,
            ],
            
            "userMessages":[
                key:           1,
            ]
            ] as [String:Any]
        
        databaseRef1.updateChildValues(userObject1)
        
    }
}

