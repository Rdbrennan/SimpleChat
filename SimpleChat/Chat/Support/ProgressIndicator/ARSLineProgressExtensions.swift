//
//  ARSLineProgressExtensions.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

//  Website: http://arsenkin.com
//

import UIKit

extension UIColor {
    
    static func ars_colorWithRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
}

func ars_dispatchAfter(_ time: Double, block: @escaping ()->()) {
    let dispatchTime = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: block)
}

func ars_dispatchOnMainQueue(_ block: @escaping ()->()) {
    DispatchQueue.main.async(execute: block)
}

