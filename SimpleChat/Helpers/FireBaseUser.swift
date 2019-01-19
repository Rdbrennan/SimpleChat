//
//  FireBaseUser.swift
//  Subly
//
//  Created by Robert Brennan on 3/30/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUser {
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let email    = dict["email"] as? String,
                let name     = dict["name"] as? String,
                let photoURL = dict["profileImageUrl"] as? String,
                let url = URL(string:photoURL) {
                
                userProfile = UserProfile(uid: snapshot.key, email: email, name: name, photoURL: url)
            }
            
            completion(userProfile)
        })
    }
}
