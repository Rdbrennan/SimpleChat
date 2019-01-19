//
//  ViewController.swift
//  SimpleChat
//
//  Created by Robert Brennan on 1/15/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import UIKit
import AccountKit

class InitialViewController: UIViewController, AKFViewControllerDelegate {
    
    //Buttons
    @IBOutlet var signUpButton: UIButton!
    var _accountKit: AKFAccountKit!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        // initialize Account Kit
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }
        //Signup button designs
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.clipsToBounds = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _accountKit?.currentAccessToken != nil{
            // if the user is already logged in, go to the main screen
            print("Already Logged in")
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NameViewController") as UIViewController
            
            self.navigationController?.pushViewController(viewController, animated: true)

        }
        else{
            // Show the login screen
        }
    }
    
    //Login preparation
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        loginViewController.setAdvancedUIManager(nil)

        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        loginViewController.setTheme(theme)
    }
    
    //Initialize phone login
    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        loginWithPhone()
    }
    func send(){
    }
}

func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
    print("did complete login with access token \(accessToken.tokenString) state \(state)")
}

// Handle successful login
func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
    print("didCompleteLoginWithAuthorizationCode")
}

// Handle canceled login
func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
    // ... handle user cancellation of the login process ...
    print("viewControllerDidCancel")
}

// Handle failed login
func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
    // ... implement appropriate error handling ...
    print("\(viewController) did fail with error: \(error.localizedDescription)")
}

func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
    print("didCompleteLoginWith")
}

