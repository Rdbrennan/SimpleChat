//
//  OnboardingController.swift
//  Subly
//
//  Created by Robert Brennan on 9/20/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class OnboardingController: UIViewController {
    
    let onboardingContainerView = OnboardingContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        view.addSubview(onboardingContainerView)
        onboardingContainerView.frame = view.bounds
        setColorsAccordingToTheme()
    }
    
    fileprivate func setColorsAccordingToTheme() {
        let theme = ThemeManager.currentTheme()
        ThemeManager.applyTheme(theme: theme)
        view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
        onboardingContainerView.backgroundColor = view.backgroundColor
    }
    
    @objc func startMessagingDidTap () {
        let destination = AuthPhoneNumberController()
        self.present(destination, animated: true, completion: nil)
    }
    
}
