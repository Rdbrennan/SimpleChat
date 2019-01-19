//
//  UIView+Extensions.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

extension UIView {
    var safeYCoordinate: CGFloat {
        let y: CGFloat
        if #available(iOS 11.0, *) {
            y = safeAreaInsets.top
        } else {
            y = 0
        }
        
        return y
    }
    
    var isiPhoneX: Bool {
        return safeYCoordinate > 20
    }
}
