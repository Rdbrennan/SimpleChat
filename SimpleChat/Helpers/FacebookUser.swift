//
//  FacebookUser.swift
//  SimpleChat
//
//  Created by Robert Brennan on 1/17/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation

struct FacebookUser {
    let name: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
