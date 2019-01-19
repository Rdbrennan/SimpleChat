//
//  User.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: String?
    var name: String?
    var bio: String?
    var photoURL: String?
    var thumbnailPhotoURL: String?
    var phoneNumber: String?
    var onlineStatus: AnyObject?
    var isSelected: Bool! = false // local only
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.bio = dictionary["bio"] as? String
        self.photoURL = dictionary["photoURL"] as? String
        self.thumbnailPhotoURL = dictionary["thumbnailPhotoURL"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.onlineStatus = dictionary["OnlineStatus"]// as? AnyObject
    }
}

extension User { // local only
    var titleFirstLetter: String {
        guard let name = name else {return "" }
        return String(name[name.startIndex]).uppercased()
    }
}
