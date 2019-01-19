//
//  CameraCell.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell {
    
    var cameraView: UIView? {
        willSet {
            cameraView?.removeFromSuperview()
        }
        didSet {
            if let cameraView = cameraView {
                contentView.addSubview(cameraView)
                setNeedsLayout()
            }
        }
    }
    
    var cameraOverlayView: UIView? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cameraView?.frame = bounds
        cameraOverlayView?.frame = bounds
    }
    
}

