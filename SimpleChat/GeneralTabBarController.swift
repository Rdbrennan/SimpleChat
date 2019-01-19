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
    
    func presentOnboardingController(above controller: UITabBarController) {
        guard Auth.auth().currentUser == nil else { return }

    }
    
    let chatsController = ChatsTableViewController()

    
    func setTabs(mainController: UITabBarController) {
        
        chatsController.delegate = mainController as? ManageAppearance

        let chatsNavigationController = UINavigationController(rootViewController: chatsController)
        
        if #available(iOS 11.0, *) {
            
            chatsNavigationController.navigationBar.prefersLargeTitles = true
        }
        
        let chatsImage = UIImage(named:"chat")
        

        let chatsTabItem = UITabBarItem(title: chatsController.title, image: chatsImage, selectedImage: UIImage(named:""))
        
        chatsController.tabBarItem = chatsTabItem
        
        let tabBarControllers = [chatsNavigationController as UIViewController]
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
        
        onceToken = 1
    }
}

extension GeneralTabBarController: ManageAppearance {
    func manageAppearance(_ chatsController: ChatsTableViewController, didFinishLoadingWith state: Bool) {
        let isBiometricalAuthEnabled = UserDefaults.standard.bool(forKey: "BiometricalAuth")

    }
}
