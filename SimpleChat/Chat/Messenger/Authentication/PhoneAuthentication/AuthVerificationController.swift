//
//  AuthVerificationController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit


class AuthVerificationController: EnterVerificationCodeController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func rightBarButtonDidTap() {
        super.rightBarButtonDidTap()
        authenticate()
    }
}

