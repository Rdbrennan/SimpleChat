//
//  FacebookUser.swift
//  SimpleChat
//
//  Created by Robert Brennan on 1/17/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation

struct FacebookUser {
    let uid: String
    let name: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
    }
}
