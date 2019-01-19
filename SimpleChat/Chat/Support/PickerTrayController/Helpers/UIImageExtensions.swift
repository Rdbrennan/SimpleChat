//
//  UIImageExtensions.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init?(bundledName name: String) {
        let bundle = Bundle(for: ImagePickerTrayController.self)
        self.init(named: name, in: bundle, compatibleWith:nil)
    }
    
}
