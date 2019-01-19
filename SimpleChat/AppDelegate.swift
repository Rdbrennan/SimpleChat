//
//  AppDelegate.swift
//  SimpleChat
//
//  Created by Robert Brennan on 1/15/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

//Global Color Themes
let primaryColor1 = Theme1.PRIMARY_COLOR
let secondaryColor = Theme1.SECONDARY_COLOR

let adminUID =  "Dk5qkgKdHmSaTH6iI0qGiHtQJuC2"
let admin1UID = "8fOPjM4qTsMghRj7i0GaJDW67L72"
let admin2UID = "7XGAL1ebPtVW4NtNp5igGZtfb5c2"
let admin3UID = "ESO3H0DGP9bLduQIJKdVyqEMilY2"
let this = "57fttrGiVIahGnVbcvtx3yiWBai1"

let newUser = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    
    let chatsController = ChatsTableViewController()
    let contactsController = ContactsController()
    let settingsController = AccountSettingsController()
    
    var orientationLock = UIInterfaceOrientationMask.allButUpsideDown


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        registerForPushNotifications()
        
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if user != nil {
                
                FirebaseUser.observeUserProfile(user!.uid) { userProfile in
                    FirebaseUser.currentUserProfile = userProfile
                }
                let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                let controller1 = ChatsTableViewController()
                 let navcontroller = UINavigationController(rootViewController: controller1)
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            } else {
                
                FirebaseUser.currentUserProfile = nil
                
                // menu screen
                let controller = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                let navcontroller = UINavigationController(rootViewController: controller)
                self.window?.rootViewController = navcontroller
                self.window?.makeKeyAndVisible()
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    //To obtain the APNs device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error.localizedDescription)")
    }
    
    //To handle push notifications
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(UIBackgroundFetchResult.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
    
    
    //MARK: Firebase Messaging
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }


}

