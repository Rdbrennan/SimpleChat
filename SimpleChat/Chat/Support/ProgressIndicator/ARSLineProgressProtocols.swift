//
//  ARSLineProgressProtocols.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

//  Website: http://arsenkin.com
//

import UIKit

@objc protocol ARSLoader {
    var emptyView: UIView { get }
    var backgroundView: UIView { get }
    @objc optional var outerCircle: CAShapeLayer { get set }
    @objc optional var middleCircle: CAShapeLayer { get set }
    @objc optional var innerCircle: CAShapeLayer { get set }
    @objc optional weak var targetView: UIView? { get set }
}

