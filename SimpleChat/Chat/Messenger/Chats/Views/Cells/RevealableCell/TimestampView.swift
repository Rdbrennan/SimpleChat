//
//  TimestampView.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class TimestampView: RevealableView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textColor = ThemeManager.currentTheme().generalSubtitleColor
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
