//
//  AnnouncementShowing.swift
//  Subly
//
//  Created by Robert Brennan on 9/21/18.
//  Copyright © 2018 TechYes. All rights reserved.
//

import UIKit

public func show(shout announcement: Announcement, to: UIViewController, completion: (() -> Void)? = nil) {
    shoutView.craft(announcement, to: to, completion: completion)
}
