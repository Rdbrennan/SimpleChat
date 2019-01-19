//
//  ChangeNumberVerificationController.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit


class ChangeNumberVerificationController: EnterVerificationCodeController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBarButton(with: "Confirm")
    }
    
    override func rightBarButtonDidTap() {
        super.rightBarButtonDidTap()
        changeNumber()
    }
}
