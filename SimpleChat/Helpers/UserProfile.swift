//
//  UserProfile.swift
//  Subly
//
//  Created by Robert Brennan on 4/2/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import Foundation

class UserProfile {
    var uid:String
    var name:String
    var email:String
    var photoURL:URL
    
    init(uid:String, email: String, name:String, photoURL:URL) {
        self.uid = uid
        self.name = name
        self.email = email
        self.photoURL = photoURL
    }
}

