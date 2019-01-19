//
//  AuthPhoneNumberController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit


class AuthPhoneNumberController: EnterPhoneNumberController {
    
    override func configurePhoneNumberContainerView() {
        super.configurePhoneNumberContainerView()
        
        phoneNumberContainerView.instructions.text = "Please confirm your country code\nand enter your phone number."
        let attributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().generalSubtitleColor]
        phoneNumberContainerView.phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone number", attributes: attributes)
    }
    
    override func rightBarButtonDidTap() {
        super.rightBarButtonDidTap()
        
        let destination = AuthVerificationController()
        destination.enterVerificationContainerView.titleNumber.text = phoneNumberContainerView.countryCode.text! + phoneNumberContainerView.phoneNumber.text!
        navigationController?.pushViewController(destination, animated: true)
    }
}
