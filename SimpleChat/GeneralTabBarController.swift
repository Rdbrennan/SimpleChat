//
//  GeneralTabBarController.swift
//  Subly
//
//  Created by Robert Brennan on 9/27/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

enum tabs: Int {
    case contacts = 0
    case chats = 1
    case settings = 2
}

class GeneralTabBarController: UITabBarController {
    
    var onceToken = 0
    
    var window: UIWindow?
    
    let splashContainer: SplashScreenContainer = {
        let splashContainer = SplashScreenContainer()
        splashContainer.translatesAutoresizingMaskIntoConstraints = false
        
        return splashContainer
    }()
    
    func presentOnboardingController(above controller: UITabBarController) {
        guard Auth.auth().currentUser == nil else { return }
        let destination = OnboardingController()
        let newNavigationController = UINavigationController(rootViewController: destination)
        newNavigationController.navigationBar.shadowImage = UIImage()
        newNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        newNavigationController.modalTransitionStyle = .crossDissolve
        controller.present(newNavigationController, animated: false, completion: nil)
    }
    
    let chatsController = ChatsTableViewController()
    let contactsController = ContactsController()
    let settingsController = AccountSettingsController()
    
    func setTabs(mainController: UITabBarController) {
        
        //    contactsController.title = "Contacts"
//        chatsController.title = "Chats"
        settingsController.title = "Settings"
        chatsController.delegate = mainController as? ManageAppearance
        
        let contactsNavigationController = UINavigationController(rootViewController: contactsController)
        let chatsNavigationController = UINavigationController(rootViewController: chatsController)
        let settingsNavigationController = UINavigationController(rootViewController: settingsController)
        
        if #available(iOS 11.0, *) {
            settingsNavigationController.navigationBar.prefersLargeTitles = true
            chatsNavigationController.navigationBar.prefersLargeTitles = true
            contactsNavigationController.navigationBar.prefersLargeTitles = true
        }
        
        let contactsImage =  UIImage(named:"user")
        let chatsImage = UIImage(named:"chat")
        let settingsImage = UIImage(named:"settings")
        
        let contactsTabItem = UITabBarItem(title: contactsController.title, image: contactsImage, selectedImage: UIImage(named:""))
        let chatsTabItem = UITabBarItem(title: chatsController.title, image: chatsImage, selectedImage: UIImage(named:""))
        let settingsTabItem = UITabBarItem(title: settingsController.title, image: settingsImage, selectedImage: UIImage(named:""))
        
        //    contactsController.tabBarItem = contactsTabItem
        chatsController.tabBarItem = chatsTabItem
        settingsController.tabBarItem = settingsTabItem
        
        let tabBarControllers = [contactsNavigationController, chatsNavigationController as UIViewController, settingsNavigationController]
        mainController.setViewControllers((tabBarControllers), animated: false)
        mainController.selectedIndex = tabs.chats.rawValue
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOnlineStatus()
        //        configureTabBar()
    }
    
    fileprivate func configureTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().generalSubtitleColor], for: .normal)
        tabBar.unselectedItemTintColor = ThemeManager.currentTheme().generalSubtitleColor
        tabBar.isTranslucent = false
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if onceToken == 0 {
            view.addSubview(splashContainer)
            splashContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            splashContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            splashContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            splashContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        onceToken = 1
    }
}

extension GeneralTabBarController: ManageAppearance {
    func manageAppearance(_ chatsController: ChatsTableViewController, didFinishLoadingWith state: Bool) {
        let isBiometricalAuthEnabled = UserDefaults.standard.bool(forKey: "BiometricalAuth")
        if state {
            if isBiometricalAuthEnabled {
                splashContainer.authenticationWithTouchID()
            } else {
                self.splashContainer.showSecuredData()
            }
        }
    }
}
