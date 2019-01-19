//
//  ARSLineProgressConstants.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

//  Website: http://arsenkin.com
//

import UIKit

let ARS_BACKGROUND_VIEW_SIDE_LENGTH: CGFloat = 125.0
let ARS_STATUS_PATH_SIDE_LENGTH: CGFloat = 125.0

let ARS_CIRCLE_ROTATION_TO_VALUE = 2 * CGFloat(Double.pi)
let ARS_CIRCLE_ROTATION_REPEAT_COUNT = Float(UINT64_MAX)
let ARS_CIRCLE_RADIUS_OUTER: CGFloat = 40.0
let ARS_CIRCLE_RADIUS_MIDDLE: CGFloat = 30.0
let ARS_CIRCLE_RADIUS_INNER: CGFloat = 20.0
let ARS_CIRCLE_LINE_WIDTH: CGFloat = 2.0
let ARS_CIRCLE_START_ANGLE: CGFloat = -CGFloat(Double.pi/2)
let ARS_CIRCLE_END_ANGLE: CGFloat = 0.0

weak var ars_currentStatus: ARSLoader?
var ars_currentLoader: ARSLoader?
var ars_currentCompletionBlock: (() -> Void)?

